// Week 2, day 2 — lists. Run: flutter test test/week_02/day_2_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shelf_app/data/sample_books.dart';
import 'package:shelf_app/domain/models/book.dart';
import 'package:shelf_app/ui/shelf/shelf_screen.dart';

void main() {
  Future<List<Book>> show(
    WidgetTester tester, {
    List<Book> books = sampleBooks,
    VoidCallback? onAdd,
    VoidCallback? onSearch,
  }) async {
    final tapped = <Book>[];
    await tester.pumpWidget(MaterialApp(
      home: ShelfScreen(
        books: books,
        onBookTap: tapped.add,
        onAdd: onAdd,
        onSearch: onSearch,
      ),
    ));
    await tester.pumpAndSettle(); // let the floating button animate in
    return tapped;
  }

  Future<void> pickShelf(WidgetTester tester, String label) async {
    await tester.tap(find.descendant(
      of: find.byKey(const Key('status-filter')),
      matching: find.text(label),
    ));
    await tester.pumpAndSettle();
  }

  testWidgets('starts on Reading', (tester) async {
    await show(tester);

    expect(find.byKey(const Key('book-1')), findsOneWidget); // Dune, reading
    expect(find.byKey(const Key('book-2')), findsNothing); // Beloved, want to read
  });

  testWidgets('shows the title and authors of each book', (tester) async {
    await show(tester);

    final row = find.byKey(const Key('book-1'));
    expect(find.descendant(of: row, matching: find.text('Dune')), findsOneWidget);
    expect(find.descendant(of: row, matching: find.text('Frank Herbert')),
        findsOneWidget);
  });

  testWidgets('a book being read shows a progress bar', (tester) async {
    await show(tester);

    expect(
      find.descendant(
        of: find.byKey(const Key('book-1')),
        matching: find.byType(LinearProgressIndicator),
      ),
      findsOneWidget,
    );
  });

  testWidgets('picking a shelf shows only its books', (tester) async {
    await show(tester);

    await pickShelf(tester, 'Want to read');
    expect(find.byKey(const Key('book-2')), findsOneWidget);
    expect(find.byKey(const Key('book-1')), findsNothing);

    await pickShelf(tester, 'Done');
    expect(find.byKey(const Key('book-3')), findsOneWidget);
    expect(find.text('Terry Pratchett, Neil Gaiman'), findsOneWidget);
  });

  testWidgets('an empty shelf says so', (tester) async {
    await show(tester, books: const []);

    expect(find.byKey(const Key('empty-shelf')), findsOneWidget);
    expect(find.text('Nothing on this shelf yet.'), findsOneWidget);
  });

  testWidgets('tapping a book reports which one', (tester) async {
    final tapped = await show(tester);

    await tester.tap(find.byKey(const Key('book-1')));

    expect(tapped.map((b) => b.id), ['1']);
  });

  testWidgets('many books scroll, and are built lazily', (tester) async {
    final many = [
      for (var i = 0; i < 200; i++)
        Book(id: 'b$i', title: 'Book $i', status: ShelfStatus.reading),
    ];
    await show(tester, books: many);

    expect(find.byKey(const Key('book-b0')), findsOneWidget);
    expect(find.byKey(const Key('book-b199')), findsNothing,
        reason: 'ListView.builder only builds the rows on screen');

    await tester.scrollUntilVisible(find.byKey(const Key('book-b199')), 500);
    expect(find.byKey(const Key('book-b199')), findsOneWidget);
  });

  testWidgets('the add and search buttons appear only when wired',
      (tester) async {
    await show(tester);
    expect(find.byKey(const Key('add-book')), findsNothing);
    expect(find.byKey(const Key('open-search')), findsNothing);

    var added = 0;
    var searched = 0;
    await show(tester, onAdd: () => added++, onSearch: () => searched++);
    await tester.tap(find.byKey(const Key('add-book')));
    await tester.tap(find.byKey(const Key('open-search')));

    expect(added, 1);
    expect(searched, 1);
  });
}
