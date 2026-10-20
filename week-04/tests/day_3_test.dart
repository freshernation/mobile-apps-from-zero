// Week 4, day 3 — books, on Firebase. Copy all of week-04/tests/ into
// shelf_v2/test/week_04/ and run: flutter test test/week_04/day_3_test.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mock_exceptions/mock_exceptions.dart';
import 'package:shelf_v2/data/repositories/books/book_repository_firebase.dart';
import 'package:shelf_v2/domain/models/book.dart';
import 'package:shelf_v2/utils/result.dart';

import '../../testing/fakes/fake_book_repository.dart';
import 'book_repository_contract.dart';

void main() {
  group('Book', () {
    final dune = Book(
      id: 'OL893414W',
      title: 'Dune',
      authors: const ['Frank Herbert'],
      pageCount: 608,
      status: ShelfStatus.reading,
      currentPage: 152,
      updatedAt: DateTime.utc(2026, 10, 20, 9, 30),
    );

    test('toJson writes updatedAt as an ISO-8601 UTC string', () {
      expect(dune.toJson()['updatedAt'], '2026-10-20T09:30:00.000Z');
      expect(dune.toJson()['status'], 'reading');
    });

    test('fromJson(toJson()) round-trips', () {
      expect(Book.fromJson(dune.toJson()), dune);
    });

    test('fromJson needs only id, title and updatedAt', () {
      final book = Book.fromJson({
        'id': '1',
        'title': 'Emma',
        'updatedAt': '2026-10-20T09:30:00Z',
      });
      expect(book.authors, isEmpty);
      expect(book.status, ShelfStatus.wantToRead);
      expect(book.currentPage, 0);
    });

    test('progress and authorLine still work', () {
      expect(dune.progress, closeTo(0.25, 0.001));
      expect(dune.authorLine, 'Frank Herbert');
    });

    test('copyWith can change updatedAt', () {
      final later = DateTime.utc(2027);
      expect(dune.copyWith(updatedAt: later).updatedAt, later);
    });

    test('fromOpenLibrary uses the time you give it', () {
      final now = DateTime.utc(2026, 1, 1);
      final book = Book.fromOpenLibrary({
        'key': '/works/OL1W',
        'title': 'Untitled',
      }, now: now);
      expect(book.id, 'OL1W');
      expect(book.updatedAt, now);
    });
  });

  final store = FakeBookStore();
  bookRepositoryContract(
    'Fake',
    // The fake has no "signed out"; the Firebase run below covers it.
    signedInAs: (email) async =>
        FakeBookRepository(userId: email, store: store),
  );

  final firestore = FakeFirebaseFirestore();
  bookRepositoryContract(
    'Firebase',
    signedInAs: (email) async => BookRepositoryFirebase(
      firestore: firestore,
      auth: MockFirebaseAuth(
        signedIn: true,
        mockUser: MockUser(uid: email, email: email),
      ),
    ),
    signedOut: () async =>
        BookRepositoryFirebase(firestore: firestore, auth: MockFirebaseAuth()),
  );

  group('BookRepositoryFirebase', () {
    late FakeFirebaseFirestore db;
    late BookRepositoryFirebase books;

    setUp(() {
      db = FakeFirebaseFirestore();
      books = BookRepositoryFirebase(
        firestore: db,
        auth: MockFirebaseAuth(
          signedIn: true,
          mockUser: MockUser(uid: 'u1', email: 'a@x.com'),
        ),
      );
    });

    Book dune() =>
        Book(id: 'OL1W', title: 'Dune', updatedAt: DateTime.utc(2000));

    test('keeps books at users/{uid}/books/{id}', () async {
      await books.addBook(dune());
      await pumpEventQueue();

      final doc = await db.doc('users/u1/books/OL1W').get();
      expect(doc.exists, isTrue);
      expect(doc.data()!['title'], 'Dune');
    });

    test('an add does not wait for the server to confirm it', () async {
      whenCalling(Invocation.method(#set, null))
          .on(db.doc('users/u1/books/OL1W'))
          .thenThrow(
            FirebaseException(plugin: 'firestore', code: 'unavailable'),
          );

      final result = await books.addBook(dune());

      expect((result as Ok<Book>).value.id, 'OL1W');
    });

    test('an update does not wait for the server to confirm it', () async {
      final added = (await books.addBook(dune()) as Ok<Book>).value;
      await pumpEventQueue();
      whenCalling(Invocation.method(#set, null))
          .on(db.doc('users/u1/books/OL1W'))
          .thenThrow(
            FirebaseException(plugin: 'firestore', code: 'unavailable'),
          );

      final result = await books.updateBook(
        added.copyWith(status: ShelfStatus.done),
      );

      expect((result as Ok<Book>).value.status, ShelfStatus.done);
    });

    test('a delete does not wait for the server to confirm it', () async {
      await books.addBook(dune());
      await pumpEventQueue();
      whenCalling(Invocation.method(#delete, null))
          .on(db.doc('users/u1/books/OL1W'))
          .thenThrow(
            FirebaseException(plugin: 'firestore', code: 'unavailable'),
          );

      expect(await books.deleteBook('OL1W'), isA<Ok<void>>());
    });
  });
}
