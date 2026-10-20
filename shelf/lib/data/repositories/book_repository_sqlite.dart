// Week 3, day 4 — books that survive a restart. Run: flutter test test/week_03/day_4_test.dart
import '../../domain/models/book.dart';
import '../../utils/result.dart';
import '../services/local_db.dart';
import 'book_repository.dart';

/// A [BookRepository] on [LocalDb]. Same promise as InMemoryBookRepository —
/// including NotFoundException for an unknown id — so the app can't tell
/// the difference, except that books are still there tomorrow.
class SqliteBookRepository implements BookRepository {
  SqliteBookRepository({required LocalDb db});

  @override
  Future<Result<List<Book>>> getBooks() =>
      throw UnimplementedError('Week 3, day 4: getBooks');

  @override
  Future<Result<Book>> addBook(Book book) =>
      throw UnimplementedError('Week 3, day 4: addBook');

  @override
  Future<Result<Book>> updateBook(Book book) =>
      throw UnimplementedError('Week 3, day 4: updateBook');

  @override
  Future<Result<void>> deleteBook(String id) =>
      throw UnimplementedError('Week 3, day 4: deleteBook');
}
