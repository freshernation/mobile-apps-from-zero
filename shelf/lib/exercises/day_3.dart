// Week 1, day 3 — async exercises. Run: flutter test test/week_01/day_3_test.dart
import '../data/sample_books.dart';

/// The title of the first book [source] finds for [query], or 'No books found'.
Future<String> firstTitleOrMessage(SampleBookSource source, String query) async {
  throw UnimplementedError('Week 1, day 3: firstTitleOrMessage');
}

/// The title of book [id], or `'No book with id $id'` when it doesn't exist.
/// Use try / on — don't check first.
Future<String> titleOrError(SampleBookSource source, String id) async {
  throw UnimplementedError('Week 1, day 3: titleOrError');
}

/// Emits [from], from - 1, ... 1 — one number every [every] — then finishes.
Stream<int> countdown(int from, {Duration every = const Duration(seconds: 1)}) async* {
  throw UnimplementedError('Week 1, day 3: countdown');
}
