// Week 3, day 1 — where books live. Ignore it until then.
import '../../domain/models/book.dart';
import '../../utils/result.dart';

/// The one place the rest of the app gets books from and saves them to.
///
/// Screens and view models only ever see this interface — never whether the
/// books are in memory, in SQLite on the phone, or on a server.
abstract class BookRepository {
  Future<Result<List<Book>>> getBooks();

  Future<Result<Book>> addBook(Book book);

  /// Replaces the book with the same id. `NotFoundException` if there is none.
  Future<Result<Book>> updateBook(Book book);

  /// `NotFoundException` if there is no book with [id].
  Future<Result<void>> deleteBook(String id);
}
