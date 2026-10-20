// Week 5, day 1 — the camera, and barcodes. Copy week-05/tests/ into
// shelf_v2/test/week_05/ and run: flutter test test/week_05/day_1_test.dart
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shelf_v2/data/services/open_library_service.dart';
import 'package:shelf_v2/domain/models/book.dart';
import 'package:shelf_v2/ui/scan/isbn.dart';
import 'package:shelf_v2/ui/scan/scan_view_model.dart';
import 'package:shelf_v2/utils/app_exceptions.dart';
import 'package:shelf_v2/utils/result.dart';

import '../../testing/fakes/fake_book_repository.dart';

const duneDoc = {
  'key': '/works/OL893414W',
  'title': 'Dune',
  'author_name': ['Frank Herbert'],
  'number_of_pages_median': 608,
};

void main() {
  group('isbnFrom', () {
    test('a valid ISBN-13 comes back as it is', () {
      expect(isbnFrom('9780441172719'), '9780441172719');
    });

    test('a 979 ISBN-13 is valid too', () {
      expect(isbnFrom('9791032305690'), '9791032305690');
    });

    test('spaces and hyphens are ignored', () {
      expect(isbnFrom('978-0-441-17271-9'), '9780441172719');
      expect(isbnFrom(' 978 0441 172719 '), '9780441172719');
    });

    test('a valid ISBN-10 becomes its ISBN-13', () {
      expect(isbnFrom('0441172717'), '9780441172719');
    });

    test('an ISBN-10 can end in X', () {
      expect(isbnFrom('080442957X'), '9780804429573');
      expect(isbnFrom('080442957x'), '9780804429573');
    });

    test('a wrong check digit is not an ISBN', () {
      expect(isbnFrom('9780441172718'), isNull);
      expect(isbnFrom('0441172718'), isNull);
    });

    test('a product barcode that is not a book is not an ISBN', () {
      expect(isbnFrom('4006381333931'), isNull); // a valid EAN-13, not 978/979
    });

    test('QR codes, URLs and junk are not ISBNs', () {
      expect(isbnFrom('https://example.com'), isNull);
      expect(isbnFrom(''), isNull);
      expect(isbnFrom('12345'), isNull);
    });
  });

  group('OpenLibraryService.byIsbn', () {
    test('asks for the ISBN and returns the book', () async {
      late Uri asked;
      final service = OpenLibraryService(
        client: MockClient((request) async {
          asked = request.url;
          return http.Response(
            jsonEncode({
              'docs': [duneDoc],
            }),
            200,
          );
        }),
      );

      final result = await service.byIsbn('9780441172719');

      expect(asked.queryParameters['isbn'], '9780441172719');
      expect((result as Ok<Book?>).value?.title, 'Dune');
    });

    test('an ISBN Open Library does not know is Ok(null)', () async {
      final service = OpenLibraryService(
        client: MockClient(
          (_) async => http.Response(jsonEncode({'docs': []}), 200),
        ),
      );

      expect(
        (await service.byIsbn('9780441172719') as Ok<Book?>).value,
        isNull,
      );
    });
  });

  group('ScanViewModel', () {
    late int requests;
    late FakeBookRepository books;
    late ScanViewModel scan;

    ScanViewModel build(
      List<Map<String, Object?>> docs, {
      List<Book> shelf = const [],
    }) {
      requests = 0;
      books = FakeBookRepository(books: shelf);
      return ScanViewModel(
        service: OpenLibraryService(
          client: MockClient((_) async {
            requests++;
            return http.Response(jsonEncode({'docs': docs}), 200);
          }),
        ),
        books: books,
      );
    }

    tearDown(() => scan.dispose());

    test('a scanned ISBN is looked up and added to Want to read', () async {
      scan = build([duneDoc]);

      await scan.onBarcode.execute('9780441172719');

      expect((scan.onBarcode.result as Ok<Book?>).value?.title, 'Dune');
      final saved = (await books.getBooks() as Ok<List<Book>>).value;
      expect(saved.single.id, 'OL893414W');
      expect(saved.single.status, ShelfStatus.wantToRead);
    });

    test('a barcode that is not an ISBN is ignored, with no request', () async {
      scan = build([duneDoc]);

      await scan.onBarcode.execute('https://example.com');

      expect(requests, 0);
      expect((scan.onBarcode.result as Ok<Book?>).value, isNull);
    });

    test('the same barcode seen again is not looked up again', () async {
      scan = build([duneDoc]);

      await scan.onBarcode.execute('9780441172719');
      await scan.onBarcode.execute('9780441172719');
      await scan.onBarcode.execute('978-0-441-17271-9');

      expect(requests, 1);
    });

    test('an ISBN Open Library does not know is NotFoundException', () async {
      scan = build([]);

      await scan.onBarcode.execute('9780441172719');

      expect((scan.onBarcode.result as Error).error, isA<NotFoundException>());
      expect((await books.getBooks() as Ok<List<Book>>).value, isEmpty);
    });

    test('scanning a book already on your shelf leaves it as it is', () async {
      final reading = Book(
        id: 'OL893414W',
        title: 'Dune',
        pageCount: 608,
        status: ShelfStatus.reading,
        currentPage: 300,
        updatedAt: DateTime.utc(2026),
      );
      scan = build([duneDoc], shelf: [reading]);

      await scan.onBarcode.execute('9780441172719');

      expect((scan.onBarcode.result as Ok<Book?>).value, reading);
      final saved = (await books.getBooks() as Ok<List<Book>>).value;
      expect(saved.single, reading, reason: 'not reset to page 0');
    });

    test('an ISBN Open Library does not know is looked up once', () async {
      scan = build([]);

      await scan.onBarcode.execute('9780441172719');
      await scan.onBarcode.execute('9780441172719');

      expect(requests, 1);
      expect((scan.onBarcode.result as Error).error, isA<NotFoundException>());
    });

    test(
      'no connection is a NetworkException, and the next scan retries',
      () async {
        var calls = 0;
        books = FakeBookRepository();
        scan = ScanViewModel(
          service: OpenLibraryService(
            client: MockClient((_) async {
              calls++;
              return calls == 1
                  ? http.Response('down', 503)
                  : http.Response(
                      jsonEncode({
                        'docs': [duneDoc],
                      }),
                      200,
                    );
            }),
          ),
          books: books,
        );

        await scan.onBarcode.execute('9780441172719');
        expect((scan.onBarcode.result as Error).error, isA<NetworkException>());

        await scan.onBarcode.execute('9780441172719');
        expect((scan.onBarcode.result as Ok<Book?>).value?.title, 'Dune');
      },
    );
  });
}
