// Week 2, day 4 — navigation and theme. Run: flutter test test/week_02/day_4_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shelf_app/app.dart';
import 'package:shelf_app/ui/add_book/add_book_screen.dart';
import 'package:shelf_app/ui/book_detail/book_detail_screen.dart';
import 'package:shelf_app/ui/core/theme.dart';
import 'package:shelf_app/ui/shelf/shelf_screen.dart';

void main() {
  Future<void> pickShelf(WidgetTester tester, String label) async {
    await tester.tap(find.descendant(
      of: find.byKey(const Key('status-filter')),
      matching: find.text(label),
    ));
    await tester.pumpAndSettle();
  }

  Future<void> start(WidgetTester tester) async {
    await tester.pumpWidget(const ShelfApp());
    await tester.pumpAndSettle();
  }

  testWidgets('starts on the shelf, with the sample books', (tester) async {
    await start(tester);

    expect(find.byType(ShelfScreen), findsOneWidget);
    expect(find.byKey(const Key('book-1')), findsOneWidget);
  });

  testWidgets('tapping a book opens it', (tester) async {
    await start(tester);

    await tester.tap(find.byKey(const Key('book-1')));
    await tester.pumpAndSettle();

    expect(find.byType(BookDetailScreen), findsOneWidget);
    expect(tester.widget<Text>(find.byKey(const Key('book-title'))).data, 'Dune');
  });

  testWidgets('back from a book returns to the shelf', (tester) async {
    await start(tester);
    await tester.tap(find.byKey(const Key('book-1')));
    await tester.pumpAndSettle();

    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.byType(ShelfScreen), findsOneWidget);
  });

  testWidgets('adding a book puts it on Want to read', (tester) async {
    await start(tester);

    await tester.tap(find.byKey(const Key('add-book')));
    await tester.pumpAndSettle();
    expect(find.byType(AddBookScreen), findsOneWidget);

    await tester.enterText(find.byKey(const Key('title-field')), 'Middlemarch');
    await tester.enterText(find.byKey(const Key('author-field')), 'George Eliot');
    await tester.tap(find.byKey(const Key('save-book')));
    await tester.pumpAndSettle();

    expect(find.byType(ShelfScreen), findsOneWidget);
    await pickShelf(tester, 'Want to read');
    expect(find.text('Middlemarch'), findsOneWidget);
  });

  testWidgets('moving a book to another shelf moves it everywhere',
      (tester) async {
    await start(tester);
    await tester.tap(find.byKey(const Key('book-1')));
    await tester.pumpAndSettle();

    await tester.tap(find.descendant(
      of: find.byKey(const Key('status-picker')),
      matching: find.text('Done'),
    ));
    await tester.pumpAndSettle();

    final chip = tester.widget<Chip>(find.byKey(const Key('book-status')));
    expect((chip.label as Text).data, 'Done', reason: 'the open screen updates');

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('book-1')), findsNothing, reason: 'off Reading');
    await pickShelf(tester, 'Done');
    expect(find.byKey(const Key('book-1')), findsOneWidget);
  });

  testWidgets('deleting a book goes back, and it is gone', (tester) async {
    await start(tester);
    await tester.tap(find.byKey(const Key('book-1')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('delete-book')));
    await tester.pumpAndSettle();

    expect(find.byType(ShelfScreen), findsOneWidget);
    expect(find.byKey(const Key('book-1')), findsNothing);
  });

  testWidgets('an unknown id shows Book not found', (tester) async {
    await start(tester);

    GoRouter.of(tester.element(find.byType(ShelfScreen))).go('/book/nope');
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('book-not-found')), findsOneWidget);
    expect(find.text('Book not found'), findsOneWidget);
  });

  group('theme', () {
    test('is Material 3, built from the Shelf brown', () {
      final light = shelfTheme(Brightness.light);
      expect(light.useMaterial3, isTrue);
      expect(light.colorScheme.brightness, Brightness.light);
      expect(light.colorScheme, ColorScheme.fromSeed(seedColor: shelfSeed));
    });

    testWidgets('follows the phone into dark mode', (tester) async {
      tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
      addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);

      await start(tester);

      final context = tester.element(find.byType(ShelfScreen));
      expect(Theme.of(context).brightness, Brightness.dark);
    });
  });
}
