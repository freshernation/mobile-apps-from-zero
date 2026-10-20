# Day 4 — Remember: saving on the phone with SQLite

> **By the end of today** Shelf remembers. Add a book, kill the app, open it again,
> and the book is still there. You did it by writing one new repository. No screen,
> and no line of the view model, changed.

Everything so far vanishes when the app closes. Today the books move into a
database on the phone. It's the payoff for Monday: you made `BookRepository` an
interface so that today you could write a second implementation and swap it in with
a single line in `main.dart`.

---

## Read first

- [ ] [Persist data with SQLite](https://docs.flutter.dev/cookbook/persistence/sqlite) · 20 min
- [ ] [Offline-first support](https://docs.flutter.dev/app-architecture/design-patterns/offline-first): the introduction · 10 min
- [ ] [sqflite](https://pub.dev/packages/sqflite): the README's *Usage example* · 10 min

---

## What you need to know

### A database on the phone

SQLite is a small SQL database that lives in one file inside your app's private
storage. It ships on every Android and iOS device, and `sqflite` is the Flutter
plugin for it.

```dart
final db = await databaseFactory.openDatabase(
  'shelf.db',
  options: OpenDatabaseOptions(
    version: 1,
    onCreate: (db, version) => db.execute(
      'CREATE TABLE books (id TEXT PRIMARY KEY, json TEXT NOT NULL)',
    ),
  ),
);
```

`onCreate` runs once, the first time the file is made. `version` is for later: when
you change the table in v2, you bump it and write an `onUpgrade` that moves old data
across. You won't need it in this course, but you'll need it in the first app you
ship and then change.

### One column of JSON

```dart
await db.insert('books', {'id': book.id, 'json': jsonEncode(book.toJson())});

final rows = await db.query('books', orderBy: 'rowid');
final books = [
  for (final row in rows) Book.fromJson(jsonDecode(row['json']! as String) as Map<String, Object?>),
];
```

A proper schema would have a column per field. For Shelf a single JSON column is
honest and small, and it reuses the `toJson`/`fromJson` you wrote in week 1 (and have
tested ever since). When you'd want real columns: as soon as you need to *query by*
a field ("all books by this author") inside the database.

### Update in place, insert if new

```dart
final updated = await db.update('books', {'json': json}, where: 'id = ?', whereArgs: [book.id]);
if (updated == 0) await db.insert('books', {'id': book.id, 'json': json});
```

Always use `?` and `whereArgs`, never `'id = ${book.id}'`. String-gluing values into SQL
is how **SQL injection** happens. `?` is how the database keeps your data separate from
your commands.

Why not `ConflictAlgorithm.replace`? A REPLACE deletes the row and re-inserts it,
which moves an edited book to the end of the list. Update-then-insert keeps it where
it was, and works on every Android version.

### The repository keeps the same promise

`SqliteBookRepository` must behave exactly like `InMemoryBookRepository`, including
`NotFoundException` for an unknown id, because the view model relies on it. That's
why today's tests repeat Monday's: same promises, new implementation. The template in
week 4 takes this further, with one **contract** test suite that every backend has to
pass.

A database error (disk full, a corrupt file) becomes an `Error` result, not a crash.

### `main` gets one line longer

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = await LocalDb.open();
  runApp(ShelfApp(repository: SqliteBookRepository(db: db)));
}
```

Plugins talk to Android and iOS, so Flutter must be running before you use them.
`ensureInitialized()` makes sure it is. Then you open the database, hand the
repository to `ShelfApp`, and that's the whole change.

### Testing on your computer

The tests use `sqflite_common_ffi`, the same SQLite running on your laptop, with a
database file in a temporary folder. One test closes the database and opens it again:
that's "kill the app and reopen" in a test.

---

## Exercises

1. `LocalDb` in `lib/data/services/local_db.dart`.
2. `SqliteBookRepository` in `lib/data/repositories/book_repository_sqlite.dart`.
3. Change `main.dart` as above.

```bash
cd shelf
flutter test test/week_03/day_4_test.dart
flutter test                     # every week — all of it must still pass
```

4. **On a device:** add a book, swipe the app away completely, open it again. It's
   still there. Then search Open Library, add a book, restart, and it's still there.
5. Notice what's missing: the sample books. A fresh database starts empty, because
   `sampleBooks` only seed the in-memory repository. Is that right for a real user?
   (It is. Don't put fake data in a real user's database.)

---

## Before tomorrow

- [ ] `flutter test`: the whole suite green.
- [ ] **Ship log:** a recording of add → kill the app → reopen → the book is there.
- [ ] Signal log.
- [ ] Read `week-03/DEFEND.md`. Tomorrow is Project 2.
