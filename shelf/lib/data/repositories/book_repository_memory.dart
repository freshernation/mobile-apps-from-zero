// Week 3, day 1 — books kept in memory. Run: flutter test test/week_03/day_1_test.dart
import '../../domain/models/book.dart';
import '../../utils/result.dart';
import 'book_repository.dart';

/// A [BookRepository] that keeps books in a list. Gone when the app closes —
/// day 4 replaces it with SQLite, and nothing above this line will notice.
class InMemoryBookRepository implements BookRepository {
  InMemoryBookRepository({List<Book> initial = const []});

  @override
  Future<Result<List<Book>>> getBooks() =>
      throw UnimplementedError('Week 3, day 1: getBooks');

  @override
  Future<Result<Book>> addBook(Book book) =>
      throw UnimplementedError('Week 3, day 1: addBook');

  @override
  Future<Result<Book>> updateBook(Book book) =>
      throw UnimplementedError('Week 3, day 1: updateBook');

  @override
  Future<Result<void>> deleteBook(String id) =>
      throw UnimplementedError('Week 3, day 1: deleteBook');
}
