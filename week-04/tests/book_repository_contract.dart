// The behaviour every BookRepository must have, whatever the backend.
// Used by day_3_test.dart — copy it into test/week_04/ with the others.
import 'package:flutter_test/flutter_test.dart';
import 'package:shelf_v2/data/repositories/books/book_repository.dart';
import 'package:shelf_v2/domain/models/book.dart';
import 'package:shelf_v2/utils/app_exceptions.dart';
import 'package:shelf_v2/utils/result.dart';

import '../contracts/contract_helpers.dart';

T ok<T>(Result<T> result) => switch (result) {
      Ok(:final value) => value,
      Error(:final error) => throw TestFailure('expected Ok, got $error'),
    };

Exception err<T>(Result<T> result) => switch (result) {
      Ok(:final value) => throw TestFailure('expected Error, got $value'),
      Error(:final error) => error,
    };

Book book(String id, {String title = 'A book'}) =>
    Book(id: id, title: title, updatedAt: DateTime.utc(2000));

Future<void> tick() => Future.delayed(const Duration(milliseconds: 20));

/// [signedInAs] returns a repository acting as the user with that email, on
/// one shared backend. [signedOut], if given, returns one with nobody
/// signed in.
void bookRepositoryContract(
  String name, {
  required Future<BookRepository> Function(String email) signedInAs,
  Future<BookRepository> Function()? signedOut,
}) {
  group('$name books.', () {
    test('starts empty', () async {
      final books = await signedInAs(uniqueEmail('empty'));
      expect(ok(await books.getBooks()), isEmpty);
    });

    test('addBook keeps the id and sets updatedAt to now', () async {
      final books = await signedInAs(uniqueEmail('add'));
      final before = DateTime.now().toUtc();

      final saved = ok(await books.addBook(book('OL1W', title: 'Dune')));

      expect(saved.id, 'OL1W');
      expect(saved.title, 'Dune');
      expect(saved.updatedAt.isBefore(before), isFalse);
      expect(ok(await books.getBook('OL1W')), saved);
    });

    test('every field survives a round trip', () async {
      final books = await signedInAs(uniqueEmail('fields'));
      final full = Book(
        id: 'OL2W',
        title: 'Good Omens',
        authors: ['Terry Pratchett', 'Neil Gaiman'],
        pageCount: 412,
        coverUrl: 'https://covers.openlibrary.org/b/id/1-M.jpg',
        status: ShelfStatus.reading,
        currentPage: 100,
        updatedAt: DateTime.utc(2000),
      );

      final saved = ok(await books.addBook(full));

      expect(ok(await books.getBook('OL2W')), saved);
      expect(saved.copyWith(updatedAt: full.updatedAt), full);
    });

    test('getBooks newest change first', () async {
      final books = await signedInAs(uniqueEmail('order'));
      await books.addBook(book('a'));
      await tick();
      await books.addBook(book('b'));
      await tick();
      final a = ok(await books.getBook('a'));
      await books.updateBook(a.copyWith(status: ShelfStatus.reading));

      expect(ok(await books.getBooks()).map((b) => b.id), ['a', 'b']);
    });

    test('updateBook saves the change and bumps updatedAt', () async {
      final books = await signedInAs(uniqueEmail('update'));
      final saved = ok(await books.addBook(book('a')));
      await tick();

      final updated = ok(await books.updateBook(
        saved.copyWith(status: ShelfStatus.done, currentPage: 5),
      ));

      expect(updated.status, ShelfStatus.done);
      expect(updated.currentPage, 5);
      expect(updated.updatedAt.isAfter(saved.updatedAt), isTrue);
      expect(ok(await books.getBook('a')), updated);
    });

    test('updateBook of a missing book is NotFoundException', () async {
      final books = await signedInAs(uniqueEmail('missing'));
      expect(err(await books.updateBook(book('nope'))), isA<NotFoundException>());
      expect(ok(await books.getBooks()), isEmpty, reason: 'nothing was added');
    });

    test('getBook of a missing book is NotFoundException', () async {
      final books = await signedInAs(uniqueEmail('get'));
      expect(err(await books.getBook('nope')), isA<NotFoundException>());
    });

    test('deleteBook removes it', () async {
      final books = await signedInAs(uniqueEmail('delete'));
      await books.addBook(book('a'));

      expect(await books.deleteBook('a'), isA<Ok<void>>());
      expect(err(await books.getBook('a')), isA<NotFoundException>());
    });

    test("user B cannot see user A's books", () async {
      final a = await signedInAs(uniqueEmail('a'));
      await a.addBook(book('private'));
      final b = await signedInAs(uniqueEmail('b'));

      expect(ok(await b.getBooks()), isEmpty);
      expect(err(await b.getBook('private')), isA<NotFoundException>());
    });

    test('signed out is NotSignedInException', skip: signedOut == null, () async {
      final books = await signedOut!();
      expect(err(await books.getBooks()), isA<NotSignedInException>());
      expect(err(await books.addBook(book('a'))), isA<NotSignedInException>());
    });
  });
}
