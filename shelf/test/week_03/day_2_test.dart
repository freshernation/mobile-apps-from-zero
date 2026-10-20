// Week 3, day 2 — the view model. Run: flutter test test/week_03/day_2_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shelf_app/app.dart';
import 'package:shelf_app/data/repositories/book_repository_memory.dart';
import 'package:shelf_app/domain/models/book.dart';
import 'package:shelf_app/ui/shelf/shelf_view_model.dart';
import 'package:shelf_app/utils/result.dart';

void main() {
  const dune = Book(
    id: '1',
    title: 'Dune',
    pageCount: 412,
    status: ShelfStatus.reading,
    currentPage: 100,
  );
  const emma = Book(id: '2', title: 'Emma');
  const omens = Book(id: '3', title: 'Good Omens', status: ShelfStatus.done);

  late InMemoryBookRepository repository;
  late ShelfViewModel shelf;

  setUp(() async {
    repository = InMemoryBookRepository(initial: [dune, emma, omens]);
    shelf = ShelfViewModel(repository: repository);
    await shelf.load.execute();
  });

  tearDown(() => shelf.dispose());

  Future<List<Book>> saved() async =>
      (await repository.getBooks() as Ok<List<Book>>).value;

  group('ShelfViewModel', () {
    test('loads the books from the repository', () {
      expect(shelf.books, [dune, emma, omens]);
    });

    test('booksWith gives one shelf', () {
      expect(shelf.booksWith(ShelfStatus.reading), [dune]);
      expect(shelf.booksWith(ShelfStatus.wantToRead), [emma]);
    });

    test('bookById finds a book, or null', () {
      expect(shelf.bookById('2'), emma);
      expect(shelf.bookById('nope'), isNull);
    });

    test('add saves the book and shows it', () async {
      const book = Book(id: '9', title: 'Piranesi');

      await shelf.add.execute(book);

      expect(shelf.books, contains(book));
      expect(await saved(), contains(book));
    });

    test('setStatus moves the book, and saves it', () async {
      await shelf.setStatus.execute((id: '2', status: ShelfStatus.reading));

      expect(shelf.bookById('2')!.status, ShelfStatus.reading);
      expect((await saved()).firstWhere((b) => b.id == '2').status,
          ShelfStatus.reading);
    });

    test('moving a book to Done puts you on its last page', () async {
      await shelf.setStatus.execute((id: '1', status: ShelfStatus.done));

      expect(shelf.bookById('1')!.currentPage, 412);
    });

    test('setPage saves the page', () async {
      await shelf.setPage.execute((id: '1', page: 200));

      expect(shelf.bookById('1')!.currentPage, 200);
      expect((await saved()).first.currentPage, 200);
    });

    test('setPage clamps to the book', () async {
      await shelf.setPage.execute((id: '1', page: 9999));
      expect(shelf.bookById('1')!.currentPage, 412);

      await shelf.setPage.execute((id: '1', page: -5));
      expect(shelf.bookById('1')!.currentPage, 0);
    });

    test('delete removes the book everywhere', () async {
      await shelf.delete.execute('3');

      expect(shelf.bookById('3'), isNull);
      expect((await saved()).map((b) => b.id), ['1', '2']);
    });

    test('changing an unknown book is an error, and changes nothing', () async {
      await shelf.setPage.execute((id: 'nope', page: 1));

      expect(shelf.setPage.error, isTrue);
      expect(shelf.books, [dune, emma, omens]);
    });

    test('tells its listeners when the books change', () async {
      var told = 0;
      shelf.addListener(() => told++);

      await shelf.add.execute(const Book(id: '9', title: 'Piranesi'));

      expect(told, greaterThanOrEqualTo(1));
    });

    test('loads by itself when it is created', () async {
      final fresh = ShelfViewModel(repository: repository);
      await pumpEventQueue();

      expect(fresh.books, hasLength(3));
      fresh.dispose();
    });
  });

  group('ShelfApp on a repository', () {
    testWidgets('shows the books from the repository it is given',
        (tester) async {
      await tester.pumpWidget(ShelfApp(
        repository: InMemoryBookRepository(initial: [
          const Book(id: 'x', title: 'Only this one', status: ShelfStatus.reading),
        ]),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Only this one'), findsOneWidget);
      expect(find.text('Dune'), findsNothing);
    });

    testWidgets('a change made on screen is saved to the repository',
        (tester) async {
      final repo = InMemoryBookRepository(initial: [dune]);
      await tester.pumpWidget(ShelfApp(repository: repo));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('book-1')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('delete-book')));
      await tester.pumpAndSettle();

      expect((await repo.getBooks() as Ok<List<Book>>).value, isEmpty);
    });
  });
}
