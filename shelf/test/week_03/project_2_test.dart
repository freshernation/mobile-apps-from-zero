// Project 2 — Shelf in layers: real search, saved on the phone.
// Run: flutter test test/week_03/project_2_test.dart
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shelf_app/app.dart';
import 'package:shelf_app/data/repositories/book_repository_sqlite.dart';
import 'package:shelf_app/data/services/local_db.dart';
import 'package:shelf_app/data/services/open_library_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  testWidgets('a book found on Open Library is still on the shelf after a restart',
      (tester) async {
    sqfliteFfiInit();
    final folder = Directory.systemTemp.createTempSync('shelf_project_2');
    addTearDown(() => folder.deleteSync(recursive: true));
    final path = '${folder.path}/shelf.db';
    // The no-isolate factory runs SQLite in the test itself, so queries
    // finish inside pumpAndSettle. Opening and closing the file are real
    // I/O, which a widget test's fake clock can't wait for: runAsync can.
    Future<LocalDb> openDb() async => (await tester.runAsync(
          () => LocalDb.open(factory: databaseFactoryFfiNoIsolate, path: path),
        ))!;
    Future<void> closeDb(LocalDb db) => tester.runAsync(db.close);

    final openLibrary = OpenLibraryService(
      client: MockClient((request) async => http.Response(
            jsonEncode({
              'docs': [
                {
                  'key': '/works/OL893414W',
                  'title': 'Dune',
                  'author_name': ['Frank Herbert'],
                  'number_of_pages_median': 608,
                }
              ],
            }),
            200,
          )),
    );

    Future<void> pickShelf(String label) async {
      await tester.tap(find.descendant(
        of: find.byKey(const Key('status-filter')),
        matching: find.text(label),
      ));
      await tester.pumpAndSettle();
    }

    // First run: an empty shelf.
    var db = await openDb();
    await tester.pumpWidget(ShelfApp(
      repository: SqliteBookRepository(db: db),
      search: openLibrary,
    ));
    await tester.pumpAndSettle();
    await pickShelf('Want to read');
    expect(find.byKey(const Key('empty-shelf')), findsOneWidget);

    // Search, and add the result.
    await tester.tap(find.byKey(const Key('open-search')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('search-field')), 'dune');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('add-OL893414W')));
    await tester.pumpAndSettle();

    // Back on the shelf, it is on Want to read.
    await tester.pageBack();
    await tester.pumpAndSettle();
    await pickShelf('Want to read');
    expect(find.text('Dune'), findsOneWidget);

    // "Restart": a new app on the same database file.
    await tester.pumpWidget(const SizedBox());
    await closeDb(db);
    db = await openDb();
    addTearDown(() => closeDb(db));
    await tester.pumpWidget(ShelfApp(
      repository: SqliteBookRepository(db: db),
      search: openLibrary,
    ));
    await tester.pumpAndSettle();
    await pickShelf('Want to read');

    expect(find.text('Dune'), findsOneWidget);
    expect(find.text('Frank Herbert'), findsOneWidget);
  });
}
