// Week 3, day 2 — the view model. Run: flutter test test/week_03/day_2_test.dart
import 'package:flutter/foundation.dart';

import '../../data/repositories/book_repository.dart';
import '../../domain/models/book.dart';
import '../../utils/command.dart';

/// Everything Shelf's screens know and do about your books.
///
/// Holds the books loaded from [repository] and exposes one Command per thing
/// a screen can do. Each command saves through the repository first, then
/// updates [books] and calls notifyListeners — so screens only show and ask.
///
/// Rules: moving a book to Done puts you on its last page; setPage keeps the
/// page between 0 and the book's page count; changing a book that doesn't
/// exist is an Error and changes nothing. `load` runs once on creation.
class ShelfViewModel extends ChangeNotifier {
  ShelfViewModel({required BookRepository repository});

  List<Book> get books => throw UnimplementedError('Week 3, day 2: books');

  List<Book> booksWith(ShelfStatus status) =>
      throw UnimplementedError('Week 3, day 2: booksWith');

  Book? bookById(String id) =>
      throw UnimplementedError('Week 3, day 2: bookById');

  Command0<void> get load => throw UnimplementedError('Week 3, day 2: load');

  Command1<void, Book> get add => throw UnimplementedError('Week 3, day 2: add');

  Command1<void, ({String id, ShelfStatus status})> get setStatus =>
      throw UnimplementedError('Week 3, day 2: setStatus');

  Command1<void, ({String id, int page})> get setPage =>
      throw UnimplementedError('Week 3, day 2: setPage');

  Command1<void, String> get delete =>
      throw UnimplementedError('Week 3, day 2: delete');
}
