// Week 4, day 4 — Shelf's screens on the template.
// Run: flutter test test/week_04/day_4_test.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:provider/provider.dart';
import 'package:shelf_v2/app.dart';
import 'package:shelf_v2/data/repositories/auth/auth_repository.dart';
import 'package:shelf_v2/data/repositories/books/book_repository.dart';
import 'package:shelf_v2/data/services/notification_service.dart';
import 'package:shelf_v2/data/services/open_library_service.dart';
import 'package:shelf_v2/domain/models/book.dart';
import 'package:shelf_v2/ui/books/book_view_model.dart';
import 'package:shelf_v2/ui/books/shelf_view_model.dart';
import 'package:shelf_v2/ui/search/search_view_model.dart';
import 'package:shelf_v2/utils/app_exceptions.dart';
import 'package:shelf_v2/utils/result.dart';

import '../../testing/fakes/fake_auth_repository.dart';
import '../../testing/fakes/fake_book_repository.dart';
import '../../testing/fakes/fake_notification_service.dart';

const duneDoc = {
  'key': '/works/OL893414W',
  'title': 'Dune',
  'author_name': ['Frank Herbert'],
  'number_of_pages_median': 608,
};

OpenLibraryService openLibrary() => OpenLibraryService(
  client: MockClient(
    (_) async => http.Response(
      jsonEncode({
        'docs': [duneDoc],
      }),
      200,
    ),
  ),
);

Book book(
  String id, {
  ShelfStatus status = ShelfStatus.reading,
  int? pages = 400,
  int page = 100,
  int minute = 0,
}) => Book(
  id: id,
  title: 'Book $id',
  pageCount: pages,
  status: status,
  currentPage: page,
  updatedAt: DateTime.utc(2026, 1, 1, 0, minute),
);

Future<List<Book>> saved(BookRepository repo) async =>
    (await repo.getBooks() as Ok<List<Book>>).value;

void main() {
  group('ShelfViewModel', () {
    late FakeBookRepository repo;
    late ShelfViewModel shelf;

    setUp(() async {
      repo = FakeBookRepository(
        books: [
          book('a', minute: 1),
          book('b', status: ShelfStatus.wantToRead, minute: 2),
        ],
      );
      shelf = ShelfViewModel(
        books: repo,
        auth: FakeAuthRepository(),
        notifications: FakeNotificationService(),
      );
      await shelf.load.execute();
    });

    tearDown(() => shelf.dispose());

    test('loads newest first, and filters by shelf', () {
      expect(shelf.books.map((b) => b.id), ['b', 'a']);
      expect(shelf.booksWith(ShelfStatus.reading).map((b) => b.id), ['a']);
    });

    test(
      'moving a book to Done puts you on its last page, and saves it',
      () async {
        await shelf.setStatus.execute((id: 'a', status: ShelfStatus.done));

        final a = (await saved(repo)).firstWhere((b) => b.id == 'a');
        expect(a.status, ShelfStatus.done);
        expect(a.currentPage, 400);
      },
    );

    test('setPage clamps to the book', () async {
      await shelf.setPage.execute((id: 'a', page: 9999));
      expect(shelf.books.firstWhere((b) => b.id == 'a').currentPage, 400);

      await shelf.setPage.execute((id: 'a', page: -3));
      expect(shelf.books.firstWhere((b) => b.id == 'a').currentPage, 0);
    });

    test('a changed book moves to the top', () async {
      await shelf.setPage.execute((id: 'a', page: 50));
      expect(shelf.books.first.id, 'a');
    });

    test('delete removes it', () async {
      await shelf.delete.execute('a');
      expect(shelf.books.map((b) => b.id), ['b']);
      expect((await saved(repo)).map((b) => b.id), ['b']);
    });

    test('a failed load is an error, not an empty shelf', () async {
      repo.failWith = const NetworkException();
      await shelf.load.execute();
      expect(shelf.load.error, isTrue);
    });
  });

  group('BookViewModel', () {
    test('loads the book, and saves changes to it', () async {
      final repo = FakeBookRepository(books: [book('a')]);
      final viewModel = BookViewModel(books: repo, bookId: 'a');
      await viewModel.load.execute();
      expect(viewModel.book?.id, 'a');

      await viewModel.setStatus.execute(ShelfStatus.done);

      expect(viewModel.book?.currentPage, 400);
      expect((await saved(repo)).single.status, ShelfStatus.done);
      viewModel.dispose();
    });

    test('a missing book is NotFoundException', () async {
      final viewModel = BookViewModel(books: FakeBookRepository(), bookId: 'x');
      await viewModel.load.execute();
      expect((viewModel.load.result as Error).error, isA<NotFoundException>());
      viewModel.dispose();
    });
  });

  group('SearchViewModel', () {
    test('adds a result on Want to read, once', () async {
      final repo = FakeBookRepository();
      final search = SearchViewModel(service: openLibrary(), books: repo);
      await search.search.execute('dune');

      await search.addToShelf.execute(search.results.single);
      await search.addToShelf.execute(search.results.single);

      final books = await saved(repo);
      expect(books, hasLength(1));
      expect(books.single.status, ShelfStatus.wantToRead);
      expect(search.isOnShelf('OL893414W'), isTrue);
      search.dispose();
    });

    test('knows the books already on your shelf', () async {
      final repo = FakeBookRepository(books: [book('OL893414W')]);
      final search = SearchViewModel(service: openLibrary(), books: repo);
      await pumpEventQueue();

      expect(search.isOnShelf('OL893414W'), isTrue);
      search.dispose();
    });
  });

  testWidgets('an empty shelf can still be pulled to refresh', (tester) async {
    final auth = FakeAuthRepository();
    await auth.signUp(email: 'a@x.com', password: 'pw');
    final repo = FakeBookRepository();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthRepository>.value(value: auth),
          Provider<BookRepository>.value(value: repo),
          Provider<NotificationService>.value(value: FakeNotificationService()),
          Provider<OpenLibraryService>.value(value: openLibrary()),
        ],
        child: const App(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('empty-shelf')), findsOneWidget);

    // Added on another phone.
    await repo.addBook(book('x'));
    await tester.drag(
      find.byKey(const Key('empty-shelf')),
      const Offset(0, 300),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('book-x')), findsOneWidget);
  });

  testWidgets('a book from search to Done to deleted', (tester) async {
    final auth = FakeAuthRepository();
    await auth.signUp(email: 'a@x.com', password: 'pw');
    final repo = FakeBookRepository();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthRepository>.value(value: auth),
          Provider<BookRepository>.value(value: repo),
          Provider<NotificationService>.value(value: FakeNotificationService()),
          Provider<OpenLibraryService>.value(value: openLibrary()),
        ],
        child: const App(),
      ),
    );
    await tester.pumpAndSettle();

    Future<void> pickShelf(String label) async {
      await tester.tap(
        find.descendant(
          of: find.byKey(const Key('status-filter')),
          matching: find.text(label),
        ),
      );
      await tester.pumpAndSettle();
    }

    // Find it and add it.
    await tester.tap(find.byKey(const Key('add-book')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('search-field')), 'dune');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('add-OL893414W')));
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();

    // It is on Want to read.
    await pickShelf('Want to read');
    expect(find.byKey(const Key('book-OL893414W')), findsOneWidget);

    // Finish it.
    await tester.tap(find.byKey(const Key('book-OL893414W')));
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(
        of: find.byKey(const Key('status-picker')),
        matching: find.text('Done'),
      ),
    );
    await tester.pumpAndSettle();
    final done = (await saved(repo)).single;
    expect(done.status, ShelfStatus.done);
    expect(done.currentPage, 608);

    // Delete it.
    await tester.tap(find.byKey(const Key('delete-book')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('confirm-delete')));
    await tester.pumpAndSettle();

    expect(await saved(repo), isEmpty);
    await pickShelf('Done');
    expect(find.byKey(const Key('empty-shelf')), findsOneWidget);
  });
}
