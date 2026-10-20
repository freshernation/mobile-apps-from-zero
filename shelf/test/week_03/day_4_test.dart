// Week 3, day 4 — saving on the phone. Run: flutter test test/week_03/day_4_test.dart
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:shelf_app/data/repositories/book_repository_sqlite.dart';
import 'package:shelf_app/data/services/local_db.dart';
import 'package:shelf_app/domain/models/book.dart';
import 'package:shelf_app/utils/app_exceptions.dart';
import 'package:shelf_app/utils/result.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late Directory folder;
  late String path;

  setUpAll(sqfliteFfiInit);

  setUp(() async {
    folder = await Directory.systemTemp.createTemp('shelf_test');
    path = '${folder.path}/shelf.db';
  });

  tearDown(() => folder.delete(recursive: true));

  Future<LocalDb> open() => LocalDb.open(factory: databaseFactoryFfi, path: path);

  const dune = Book(
    id: '1',
    title: 'Dune',
    authors: ['Frank Herbert'],
    pageCount: 412,
    status: ShelfStatus.reading,
    currentPage: 100,
  );
  const emma = Book(id: '2', title: 'Emma');

  group('LocalDb', () {
    test('a new database has no books', () async {
      final db = await open();
      expect(await db.allBooks(), isEmpty);
      await db.close();
    });

    test('upsert then allBooks gives the book back, every field', () async {
      final db = await open();
      await db.upsert(dune);
      expect(await db.allBooks(), [dune]);
      await db.close();
    });

    test('upsert of the same id replaces it', () async {
      final db = await open();
      await db.upsert(dune);
      await db.upsert(dune.copyWith(currentPage: 200));
      expect((await db.allBooks()).single.currentPage, 200);
      await db.close();
    });

    test('remove deletes it', () async {
      final db = await open();
      await db.upsert(dune);
      await db.upsert(emma);
      await db.remove('1');
      expect(await db.allBooks(), [emma]);
      await db.close();
    });

    test('books survive closing and opening again', () async {
      final first = await open();
      await first.upsert(dune);
      await first.close();

      final second = await open();
      expect(await second.allBooks(), [dune]);
      await second.close();
    });
  });

  group('SqliteBookRepository', () {
    late LocalDb db;
    late SqliteBookRepository repo;

    setUp(() async {
      db = await open();
      repo = SqliteBookRepository(db: db);
    });

    tearDown(() => db.close());

    T ok<T>(Result<T> result) => (result as Ok<T>).value;
    Exception err<T>(Result<T> result) => (result as Error<T>).error;

    test('add, then get', () async {
      expect(ok(await repo.addBook(dune)), dune);
      expect(ok(await repo.getBooks()), [dune]);
    });

    test('update replaces the book', () async {
      await repo.addBook(dune);
      final moved = dune.copyWith(status: ShelfStatus.done);

      expect(ok(await repo.updateBook(moved)), moved);
      expect(ok(await repo.getBooks()), [moved]);
    });

    test('update of an unknown id is NotFoundException', () async {
      expect(err(await repo.updateBook(emma)), isA<NotFoundException>());
      expect(ok(await repo.getBooks()), isEmpty, reason: 'and nothing was added');
    });

    test('delete removes the book', () async {
      await repo.addBook(dune);

      expect(await repo.deleteBook('1'), isA<Ok<void>>());
      expect(ok(await repo.getBooks()), isEmpty);
    });

    test('delete of an unknown id is NotFoundException', () async {
      expect(err(await repo.deleteBook('9')), isA<NotFoundException>());
    });

    test('a book added through one repository is there for the next', () async {
      await repo.addBook(dune);
      await db.close();

      db = await open();
      final again = SqliteBookRepository(db: db);
      expect(ok(await again.getBooks()), [dune]);
    });
  });
}
