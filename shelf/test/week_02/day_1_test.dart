// Week 2, day 1 — state that changes. Run: flutter test test/week_02/day_1_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shelf_app/domain/models/book.dart';
import 'package:shelf_app/ui/book_detail/book_detail_screen.dart';
import 'package:shelf_app/ui/book_detail/reading_progress.dart';

void main() {
  const dune = Book(
    id: '1',
    title: 'Dune',
    pageCount: 412,
    status: ShelfStatus.reading,
    currentPage: 100,
  );

  String label(WidgetTester tester) =>
      tester.widget<Text>(find.byKey(const Key('progress-label'))).data!;

  group('ReadingProgress', () {
    late List<int> changes;

    Future<void> show(WidgetTester tester, Book book) {
      changes = [];
      return tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ReadingProgress(book: book, onPageChanged: changes.add),
        ),
      ));
    }

    testWidgets('starts at the current page', (tester) async {
      await show(tester, dune);
      expect(label(tester), 'Page 100 of 412');
    });

    testWidgets('tapping the middle moves there, and reports it once',
        (tester) async {
      await show(tester, dune);

      await tester.tap(find.byKey(const Key('progress-slider')));
      await tester.pumpAndSettle();

      expect(changes, hasLength(1));
      expect(changes.single, inInclusiveRange(180, 232));
      expect(label(tester), 'Page ${changes.single} of 412');
    });

    testWidgets('dragging updates the label as you go', (tester) async {
      await show(tester, dune);
      final slider = find.byKey(const Key('progress-slider'));

      final gesture = await tester.startGesture(tester.getCenter(slider));
      await gesture.moveBy(const Offset(40, 0));
      await tester.pump();

      expect(label(tester), isNot('Page 100 of 412'));
      expect(changes, isEmpty, reason: 'report only when the drag ends');

      await gesture.up();
      await tester.pumpAndSettle();
      expect(changes, hasLength(1));
    });

    testWidgets('cannot go past the last page', (tester) async {
      await show(tester, dune);

      await tester.drag(
          find.byKey(const Key('progress-slider')), const Offset(2000, 0));
      await tester.pumpAndSettle();

      expect(label(tester), 'Page 412 of 412');
      expect(changes.last, 412);
    });

    testWidgets('an unknown page count asks for one instead', (tester) async {
      await show(tester, const Book(id: '2', title: 'T', status: ShelfStatus.reading));

      expect(find.byKey(const Key('progress-unknown')), findsOneWidget);
      expect(find.text('Add a page count to track progress'), findsOneWidget);
      expect(find.byKey(const Key('progress-slider')), findsNothing);
    });
  });

  group('BookDetailScreen with callbacks', () {
    testWidgets('picking a shelf reports it', (tester) async {
      final picked = <ShelfStatus>[];
      await tester.pumpWidget(MaterialApp(
        home: BookDetailScreen(book: dune, onStatusChanged: picked.add),
      ));

      await tester.tap(find.descendant(
        of: find.byKey(const Key('status-picker')),
        matching: find.text('Done'),
      ));
      await tester.pumpAndSettle();

      expect(picked, [ShelfStatus.done]);
    });

    testWidgets('delete reports it', (tester) async {
      var deleted = 0;
      await tester.pumpWidget(MaterialApp(
        home: BookDetailScreen(book: dune, onDelete: () => deleted++),
      ));

      await tester.tap(find.byKey(const Key('delete-book')));
      await tester.pumpAndSettle();

      expect(deleted, 1);
    });

    testWidgets('a book being read shows its progress', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: BookDetailScreen(book: dune, onPageChanged: (_) {}),
      ));

      expect(find.byType(ReadingProgress), findsOneWidget);
    });

    testWidgets('a book not being read hides the progress', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: BookDetailScreen(
          book: dune.copyWith(status: ShelfStatus.wantToRead),
          onPageChanged: (_) {},
        ),
      ));

      expect(find.byType(ReadingProgress), findsNothing);
    });

    testWidgets('with no callbacks there is no picker and no delete',
        (tester) async {
      await tester.pumpWidget(const MaterialApp(home: BookDetailScreen(book: dune)));

      expect(find.byKey(const Key('status-picker')), findsNothing);
      expect(find.byKey(const Key('delete-book')), findsNothing);
      expect(find.byType(ReadingProgress), findsNothing);
    });
  });
}
