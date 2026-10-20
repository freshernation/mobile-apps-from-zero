// Week 3, day 4 — SQLite on the phone. Run: flutter test test/week_03/day_4_test.dart
import 'package:sqflite/sqflite.dart';

import '../../domain/models/book.dart';

/// The on-device database: one table, `books(id TEXT PRIMARY KEY, json TEXT
/// NOT NULL)`, each row a Book stored with toJson.
///
/// The app calls `LocalDb.open()`. Tests pass `databaseFactoryFfi` and a path
/// in a temporary folder, so they run on your computer.
class LocalDb {
  LocalDb._(this._db);

  // ignore: unused_field
  final Database _db;

  static Future<LocalDb> open({
    DatabaseFactory? factory,
    String path = 'shelf.db',
  }) =>
      throw UnimplementedError('Week 3, day 4: open');

  Future<List<Book>> allBooks() =>
      throw UnimplementedError('Week 3, day 4: allBooks');

  /// Inserts the book, or replaces the one with the same id.
  Future<void> upsert(Book book) =>
      throw UnimplementedError('Week 3, day 4: upsert');

  Future<void> remove(String id) =>
      throw UnimplementedError('Week 3, day 4: remove');

  Future<void> close() => throw UnimplementedError('Week 3, day 4: close');
}
