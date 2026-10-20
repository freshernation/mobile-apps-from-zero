// Week 3, day 3 — a real API. Run: flutter test test/week_03/day_3_test.dart
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shelf_app/data/repositories/book_repository_memory.dart';
import 'package:shelf_app/data/services/open_library_service.dart';
import 'package:shelf_app/domain/models/book.dart';
import 'package:shelf_app/ui/search/search_screen.dart';
import 'package:shelf_app/ui/search/search_view_model.dart';
import 'package:shelf_app/ui/shelf/shelf_view_model.dart';
import 'package:shelf_app/utils/app_exceptions.dart';
import 'package:shelf_app/utils/result.dart';

/// What openlibrary.org/search.json sends back (trimmed to the fields we ask for).
const duneDoc = {
  'key': '/works/OL893414W',
  'title': 'Dune',
  'author_name': ['Frank Herbert'],
  'number_of_pages_median': 608,
  'cover_i': 11481354,
};

String searchReply(List<Map<String, Object?>> docs) =>
    jsonEncode({'numFound': docs.length, 'docs': docs});

void main() {
  group('Book.fromOpenLibrary', () {
    test('reads a full result', () {
      expect(
        Book.fromOpenLibrary(duneDoc),
        const Book(
          id: 'OL893414W',
          title: 'Dune',
          authors: ['Frank Herbert'],
          pageCount: 608,
          coverUrl: 'https://covers.openlibrary.org/b/id/11481354-M.jpg',
        ),
      );
    });

    test('missing fields default safely', () {
      final book = Book.fromOpenLibrary({'key': '/works/OL1W', 'title': 'Untitled'});

      expect(book.id, 'OL1W');
      expect(book.authors, isEmpty);
      expect(book.pageCount, isNull);
      expect(book.coverUrl, isNull);
      expect(book.status, ShelfStatus.wantToRead);
    });
  });

  group('OpenLibraryService', () {
    test('asks for the right URL, fields and User-Agent', () async {
      late http.Request sent;
      final service = OpenLibraryService(
        client: MockClient((request) async {
          sent = request;
          return http.Response(searchReply([duneDoc]), 200);
        }),
      );

      final result = await service.search('  dune messiah ');

      expect(sent.method, 'GET');
      expect(sent.url.host, 'openlibrary.org');
      expect(sent.url.path, '/search.json');
      expect(sent.url.queryParameters['q'], 'dune messiah');
      expect(sent.url.queryParameters['limit'], '20');
      expect(sent.url.queryParameters['fields'],
          'key,title,author_name,number_of_pages_median,cover_i');
      expect(sent.headers['User-Agent'], 'ShelfApp/1.0 (course project)');
      expect((result as Ok<List<Book>>).value.single.title, 'Dune');
    });

    test('a blank query sends no request', () async {
      var requests = 0;
      final service = OpenLibraryService(
        client: MockClient((_) async {
          requests++;
          return http.Response(searchReply([]), 200);
        }),
      );

      final result = await service.search('   ');

      expect(requests, 0);
      expect((result as Ok<List<Book>>).value, isEmpty);
    });

    test('a 500 is a NetworkException', () async {
      final service = OpenLibraryService(
        client: MockClient((_) async => http.Response('oops', 500)),
      );

      expect((await service.search('dune') as Error).error, isA<NetworkException>());
    });

    test('no connection is a NetworkException', () async {
      final service = OpenLibraryService(
        client: MockClient((_) => throw const SocketException('offline')),
      );

      expect((await service.search('dune') as Error).error, isA<NetworkException>());
    });

    test('a reply that is not JSON is a NetworkException', () async {
      final service = OpenLibraryService(
        client: MockClient((_) async => http.Response('<html>wifi login</html>', 200)),
      );

      expect((await service.search('dune') as Error).error, isA<NetworkException>());
    });
  });

  group('SearchViewModel', () {
    late ShelfViewModel shelf;
    late SearchViewModel search;

    setUp(() async {
      shelf = ShelfViewModel(repository: InMemoryBookRepository());
      await shelf.load.execute();
      search = SearchViewModel(
        service: OpenLibraryService(
          client: MockClient((_) async => http.Response(searchReply([duneDoc]), 200)),
        ),
        shelf: shelf,
      );
    });

    tearDown(() {
      search.dispose();
      shelf.dispose();
    });

    test('search fills the results', () async {
      await search.search.execute('dune');

      expect(search.results.map((b) => b.title), ['Dune']);
    });

    test('addToShelf puts the book on Want to read', () async {
      await search.search.execute('dune');

      await search.addToShelf.execute(search.results.single);

      expect(shelf.bookById('OL893414W')?.status, ShelfStatus.wantToRead);
      expect(search.isOnShelf('OL893414W'), isTrue);
    });

    test('adding a book already on the shelf does nothing', () async {
      await search.search.execute('dune');
      final dune = search.results.single;

      await search.addToShelf.execute(dune);
      await search.addToShelf.execute(dune);

      expect(shelf.books.where((b) => b.id == dune.id), hasLength(1));
    });
  });

  group('SearchScreen', () {
    Future<void> show(WidgetTester tester, MockClient client) async {
      final shelf = ShelfViewModel(repository: InMemoryBookRepository());
      final viewModel = SearchViewModel(
        service: OpenLibraryService(client: client),
        shelf: shelf,
      );
      addTearDown(viewModel.dispose);
      addTearDown(shelf.dispose);
      await tester.pumpWidget(MaterialApp(home: SearchScreen(viewModel: viewModel)));
    }

    Future<void> searchFor(WidgetTester tester, String query) async {
      await tester.enterText(find.byKey(const Key('search-field')), query);
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();
    }

    testWidgets('the search box does not autocorrect titles', (tester) async {
      await show(tester, MockClient((_) async => http.Response(searchReply([]), 200)));

      final field = tester.widget<TextField>(find.byKey(const Key('search-field')));

      expect(field.autocorrect, isFalse, reason: 'iOS turns "piranesi" into "pirates I"');
      expect(field.enableSuggestions, isFalse);
    });

    testWidgets('no results says so', (tester) async {
      await show(tester, MockClient((_) async => http.Response(searchReply([]), 200)));

      await searchFor(tester, 'zzz');

      expect(find.byKey(const Key('search-empty')), findsOneWidget);
      expect(find.text('No books match'), findsOneWidget);
    });

    testWidgets('a failure shows an error, and retry searches again',
        (tester) async {
      var calls = 0;
      await show(tester, MockClient((_) async {
        calls++;
        return calls == 1
            ? http.Response('down', 503)
            : http.Response(searchReply([duneDoc]), 200);
      }));

      await searchFor(tester, 'dune');
      expect(find.byKey(const Key('search-error')), findsOneWidget);

      await tester.tap(find.byKey(const Key('retry')));
      await tester.pumpAndSettle();

      expect(calls, 2);
      expect(find.byKey(const Key('result-OL893414W')), findsOneWidget);
    });

    testWidgets('adding a result turns its button into a check', (tester) async {
      await show(tester,
          MockClient((_) async => http.Response(searchReply([duneDoc]), 200)));
      await searchFor(tester, 'dune');

      final add = find.byKey(const Key('add-OL893414W'));
      expect(find.descendant(of: add, matching: find.byIcon(Icons.add)), findsOneWidget);

      await tester.tap(add);
      await tester.pumpAndSettle();

      expect(find.descendant(of: add, matching: find.byIcon(Icons.check)),
          findsOneWidget);
    });
  });
}
