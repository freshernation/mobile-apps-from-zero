// Week 1, day 2 — the Book model. Run: flutter test test/week_01/day_2_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:shelf_app/domain/models/book.dart';

void main() {
  const dune = Book(
    id: '1',
    title: 'Dune',
    authors: ['Frank Herbert'],
    pageCount: 412,
    coverUrl: 'https://covers.openlibrary.org/b/id/1-M.jpg',
    status: ShelfStatus.reading,
    currentPage: 103,
  );

  group('ShelfStatus', () {
    test('has a label for each shelf', () {
      expect(ShelfStatus.wantToRead.label, 'Want to read');
      expect(ShelfStatus.reading.label, 'Reading');
      expect(ShelfStatus.done.label, 'Done');
    });
  });

  group('defaults', () {
    test('a new book has no authors, no page count, and is on Want to read', () {
      const book = Book(id: '9', title: 'Untitled');
      expect(book.authors, isEmpty);
      expect(book.pageCount, isNull);
      expect(book.coverUrl, isNull);
      expect(book.status, ShelfStatus.wantToRead);
      expect(book.currentPage, 0);
    });
  });

  group('authorLine', () {
    test('no authors', () {
      expect(const Book(id: '1', title: 'T').authorLine, 'Unknown author');
    });

    test('one author', () {
      expect(dune.authorLine, 'Frank Herbert');
    });

    test('two authors, joined with a comma', () {
      const book = Book(id: '1', title: 'T', authors: ['Terry Pratchett', 'Neil Gaiman']);
      expect(book.authorLine, 'Terry Pratchett, Neil Gaiman');
    });
  });

  group('progress', () {
    test('is currentPage over pageCount', () {
      expect(dune.progress, closeTo(0.25, 0.001));
    });

    test('is 0 when the page count is unknown', () {
      const book = Book(id: '1', title: 'T', currentPage: 50);
      expect(book.progress, 0);
    });

    test('is 0 when the page count is 0', () {
      const book = Book(id: '1', title: 'T', pageCount: 0, currentPage: 5);
      expect(book.progress, 0);
    });

    test('never goes above 1', () {
      const book = Book(id: '1', title: 'T', pageCount: 100, currentPage: 150);
      expect(book.progress, 1);
    });
  });

  group('copyWith', () {
    test('changes only the fields you pass', () {
      final moved = dune.copyWith(status: ShelfStatus.done, currentPage: 412);
      expect(moved.status, ShelfStatus.done);
      expect(moved.currentPage, 412);
      expect(moved.title, dune.title);
      expect(moved.authors, dune.authors);
      expect(moved.pageCount, dune.pageCount);
      expect(moved.coverUrl, dune.coverUrl);
      expect(moved.id, dune.id);
    });

    test('with nothing passed, gives an equal book', () {
      expect(dune.copyWith(), dune);
    });
  });

  group('equality', () {
    test('two books with the same values are ==', () {
      const a = Book(id: '1', title: 'T', authors: ['A', 'B']);
      final b = Book(id: '1', title: 'T', authors: ['A', 'B'].toList());
      expect(a == b, isTrue);
      expect(a.hashCode, b.hashCode);
    });

    test('a different author makes them different', () {
      const a = Book(id: '1', title: 'T', authors: ['A']);
      const b = Book(id: '1', title: 'T', authors: ['B']);
      expect(a == b, isFalse);
    });
  });

  group('JSON', () {
    test('toJson uses these keys, and the status by name', () {
      expect(dune.toJson(), {
        'id': '1',
        'title': 'Dune',
        'authors': ['Frank Herbert'],
        'pageCount': 412,
        'coverUrl': 'https://covers.openlibrary.org/b/id/1-M.jpg',
        'status': 'reading',
        'currentPage': 103,
      });
    });

    test('fromJson(toJson()) round-trips', () {
      expect(Book.fromJson(dune.toJson()), dune);
    });

    test('fromJson accepts missing optional fields', () {
      final book = Book.fromJson({'id': '7', 'title': 'Emma'});
      expect(book, const Book(id: '7', title: 'Emma'));
    });
  });
}
