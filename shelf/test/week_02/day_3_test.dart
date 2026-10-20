// Week 2, day 3 — forms. Run: flutter test test/week_02/day_3_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shelf_app/domain/models/book.dart';
import 'package:shelf_app/ui/add_book/add_book_screen.dart';

void main() {
  late List<Book> added;

  Future<void> show(WidgetTester tester) {
    added = [];
    return tester.pumpWidget(MaterialApp(home: AddBookScreen(onAdd: added.add)));
  }

  Future<void> fill(
    WidgetTester tester, {
    String title = '',
    String author = '',
    String pages = '',
  }) async {
    await tester.enterText(find.byKey(const Key('title-field')), title);
    await tester.enterText(find.byKey(const Key('author-field')), author);
    await tester.enterText(find.byKey(const Key('pages-field')), pages);
    await tester.tap(find.byKey(const Key('save-book')));
    await tester.pumpAndSettle();
  }

  testWidgets('saves a book with what you typed, trimmed', (tester) async {
    await show(tester);

    await fill(tester, title: '  Middlemarch ', author: ' George Eliot ', pages: ' 880 ');

    final book = added.single;
    expect(book.title, 'Middlemarch');
    expect(book.authors, ['George Eliot']);
    expect(book.pageCount, 880);
    expect(book.status, ShelfStatus.wantToRead);
    expect(book.currentPage, 0);
    expect(book.id, isNotEmpty);
  });

  testWidgets('commas split several authors', (tester) async {
    await show(tester);

    await fill(tester, title: 'Good Omens', author: 'Terry Pratchett,Neil Gaiman ,');

    expect(added.single.authors, ['Terry Pratchett', 'Neil Gaiman']);
  });

  testWidgets('pages can be left empty', (tester) async {
    await show(tester);

    await fill(tester, title: 'Emma', author: 'Jane Austen');

    expect(added.single.pageCount, isNull);
  });

  testWidgets('title and author are required', (tester) async {
    await show(tester);

    await fill(tester, title: '   ');

    expect(find.text('Required'), findsNWidgets(2));
    expect(added, isEmpty);
  });

  for (final bad in ['abc', '0', '-5', '12.5']) {
    testWidgets('pages "$bad" is rejected', (tester) async {
      await show(tester);

      await fill(tester, title: 'Emma', author: 'Jane Austen', pages: bad);

      expect(find.text('Enter a whole number above 0'), findsOneWidget);
      expect(added, isEmpty);
    });
  }

  testWidgets('two books saved get different ids', (tester) async {
    await show(tester);

    await fill(tester, title: 'A', author: 'X');
    await fill(tester, title: 'B', author: 'Y');

    expect(added, hasLength(2));
    expect(added[0].id, isNot(added[1].id));
  });
}
