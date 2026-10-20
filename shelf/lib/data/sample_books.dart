// Week 1, day 3 — a pretend book source, so you can practise async code before
// there is a real server.
//
// `sampleBooks` is given. Write `SampleBookSource`, then the functions in
// lib/exercises/day_3.dart. Run: flutter test test/week_01/day_3_test.dart
import '../domain/models/book.dart';

/// Three books to start with: one on each shelf.
const sampleBooks = <Book>[
  Book(
    id: '1',
    title: 'Dune',
    authors: ['Frank Herbert'],
    pageCount: 412,
    status: ShelfStatus.reading,
    currentPage: 103,
  ),
  Book(
    id: '2',
    title: 'Beloved',
    authors: ['Toni Morrison'],
    pageCount: 324,
    status: ShelfStatus.wantToRead,
  ),
  Book(
    id: '3',
    title: 'Good Omens',
    authors: ['Terry Pratchett', 'Neil Gaiman'],
    status: ShelfStatus.done,
  ),
];

/// Thrown by [SampleBookSource.byId] when there is no book with that [id].
class BookNotFoundException implements Exception {
  const BookNotFoundException(this.id);

  final String id;

  @override
  String toString() => 'BookNotFoundException: $id';
}

/// Answers like a slow server would: after [delay].
class SampleBookSource {
  SampleBookSource({
    this.delay = const Duration(milliseconds: 300),
    this.books = sampleBooks,
  });

  final Duration delay;
  final List<Book> books;

  /// Books whose title or any author contains [query], ignoring case.
  /// A blank query finds nothing. Waits [delay] first.
  Future<List<Book>> search(String query) async {
    throw UnimplementedError('Week 1, day 3: search');
  }

  /// The book with [id]. Throws [BookNotFoundException] if there is none.
  /// Waits [delay] first.
  Future<Book> byId(String id) async {
    throw UnimplementedError('Week 1, day 3: byId');
  }
}
