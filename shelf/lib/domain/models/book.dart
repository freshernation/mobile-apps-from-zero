// Week 1, day 2 — the Book model.
//
// Everything Shelf knows about a book lives in this one class. The fields and the
// constructor are written for you; read them line by line — every `?` and every
// default is a decision. Then replace each `throw UnimplementedError(...)`:
//
//   flutter test test/week_01/day_2_test.dart

/// Which shelf a book is on.
enum ShelfStatus {
  wantToRead,
  reading,
  done;

  /// 'Want to read', 'Reading' or 'Done'.
  String get label => throw UnimplementedError('Week 1, day 2: label');
}

/// A book on your shelf. Immutable: change it with [copyWith].
class Book {
  const Book({
    required this.id,
    required this.title,
    this.authors = const [],
    this.pageCount,
    this.coverUrl,
    this.status = ShelfStatus.wantToRead,
    this.currentPage = 0,
  });

  final String id;
  final String title;
  final List<String> authors;

  /// Null when we don't know how long the book is.
  final int? pageCount;

  /// Null when there is no cover picture.
  final String? coverUrl;

  final ShelfStatus status;
  final int currentPage;

  /// 'Frank Herbert', 'Terry Pratchett, Neil Gaiman', or 'Unknown author'.
  String get authorLine => throw UnimplementedError('Week 1, day 2: authorLine');

  /// How far through the book you are, from 0 to 1. 0 when the page count is
  /// unknown or 0.
  double get progress => throw UnimplementedError('Week 1, day 2: progress');

  /// A copy with the given fields changed and every other field the same.
  Book copyWith({
    String? title,
    List<String>? authors,
    int? pageCount,
    String? coverUrl,
    ShelfStatus? status,
    int? currentPage,
  }) =>
      throw UnimplementedError('Week 1, day 2: copyWith');

  /// Keys: id, title, authors, pageCount, coverUrl, status (by name), currentPage.
  Map<String, Object?> toJson() =>
      throw UnimplementedError('Week 1, day 2: toJson');

  factory Book.fromJson(Map<String, Object?> json) =>
      throw UnimplementedError('Week 1, day 2: fromJson');

  // Week 3, day 3 — ignore until then.
  /// A book from one Open Library search result ("doc"): its `key` without
  /// the '/works/' prefix as the id, `title`, `author_name`,
  /// `number_of_pages_median` as the page count, and a cover URL from
  /// `cover_i` (`https://covers.openlibrary.org/b/id/COVER_I-M.jpg`). Missing
  /// fields mean no authors, no page count, no cover.
  factory Book.fromOpenLibrary(Map<String, Object?> doc) =>
      throw UnimplementedError('Week 3, day 3: fromOpenLibrary');

  // TODO(week 1, day 2): override == and hashCode, so two books with the same
  // values are equal. The lesson explains why you need both.
}
