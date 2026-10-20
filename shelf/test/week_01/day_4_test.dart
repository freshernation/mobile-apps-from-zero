// Week 1, day 4 — your first screen. Run: flutter test test/week_01/day_4_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shelf_app/domain/models/book.dart';
import 'package:shelf_app/ui/book_detail/book_detail_screen.dart';

void main() {
  const dune = Book(
    id: '1',
    title: 'Dune',
    authors: ['Frank Herbert'],
    pageCount: 412,
    status: ShelfStatus.reading,
  );

  Future<void> show(WidgetTester tester, Book book) =>
      tester.pumpWidget(MaterialApp(home: BookDetailScreen(book: book)));

  String textOf(WidgetTester tester, String key) =>
      tester.widget<Text>(find.byKey(Key(key))).data!;

  testWidgets('shows the title', (tester) async {
    await show(tester, dune);
    expect(textOf(tester, 'book-title'), 'Dune');
  });

  testWidgets('shows the authors', (tester) async {
    await show(tester, dune);
    expect(textOf(tester, 'book-authors'), 'Frank Herbert');
  });

  testWidgets('a book with no authors says so', (tester) async {
    await show(tester, const Book(id: '2', title: 'Anon'));
    expect(textOf(tester, 'book-authors'), 'Unknown author');
  });

  testWidgets('shows the page count', (tester) async {
    await show(tester, dune);
    expect(textOf(tester, 'book-pages'), '412 pages');
  });

  testWidgets('an unknown page count says so', (tester) async {
    await show(tester, const Book(id: '2', title: 'Anon'));
    expect(textOf(tester, 'book-pages'), 'Page count unknown');
  });

  testWidgets('shows the shelf as a chip', (tester) async {
    await show(tester, dune);
    final chip = tester.widget<Chip>(find.byKey(const Key('book-status')));
    expect((chip.label as Text).data, 'Reading');
  });

  testWidgets('no cover shows the placeholder icon', (tester) async {
    await show(tester, dune);
    expect(find.byKey(const Key('cover-placeholder')), findsOneWidget);
    expect(find.byKey(const Key('cover-image')), findsNothing);
  });

  testWidgets('a cover shows an image that falls back to the placeholder',
      (tester) async {
    await show(tester, dune.copyWith(coverUrl: 'https://example.com/c.jpg'));
    expect(find.byKey(const Key('cover-image')), findsOneWidget);
    final image = tester.widget<Image>(find.byKey(const Key('cover-image')));
    expect(image.errorBuilder, isNotNull,
        reason: 'a cover that fails to load must not show a red error box');
  });

  testWidgets('has an app bar titled with the book', (tester) async {
    await show(tester, dune);
    expect(find.descendant(of: find.byType(AppBar), matching: find.text('Dune')),
        findsOneWidget);
  });
}
