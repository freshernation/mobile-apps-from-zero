// Project 1 — Shelf works, in memory, across every screen.
// Run: flutter test test/week_02/project_1_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shelf_app/app.dart';

void main() {
  testWidgets('a book from added to deleted', (tester) async {
    Future<void> settle() => tester.pumpAndSettle();
    Future<void> pickShelf(String label) async {
      await tester.tap(find.descendant(
        of: find.byKey(const Key('status-filter')),
        matching: find.text(label),
      ));
      await settle();
    }

    await tester.pumpWidget(const ShelfApp());
    await settle();

    // Add it.
    await tester.tap(find.byKey(const Key('add-book')));
    await settle();
    await tester.enterText(find.byKey(const Key('title-field')), 'Piranesi');
    await tester.enterText(find.byKey(const Key('author-field')), 'Susanna Clarke');
    await tester.enterText(find.byKey(const Key('pages-field')), '272');
    await tester.tap(find.byKey(const Key('save-book')));
    await settle();

    // It is on Want to read.
    await pickShelf('Want to read');
    expect(find.text('Piranesi'), findsOneWidget);

    // Start reading it.
    await tester.tap(find.text('Piranesi'));
    await settle();
    await tester.tap(find.descendant(
      of: find.byKey(const Key('status-picker')),
      matching: find.text('Reading'),
    ));
    await settle();

    // Read to the end of the slider.
    await tester.drag(find.byKey(const Key('progress-slider')), const Offset(2000, 0));
    await settle();
    expect(find.text('Page 272 of 272'), findsOneWidget);

    // Back on the shelf, it is under Reading, with its progress.
    await tester.pageBack();
    await settle();
    await pickShelf('Reading');
    expect(find.text('Piranesi'), findsOneWidget);
    final bar = tester.widgetList<LinearProgressIndicator>(
      find.byType(LinearProgressIndicator),
    );
    expect(bar.map((b) => b.value), contains(1.0));

    // Delete it.
    await tester.tap(find.text('Piranesi'));
    await settle();
    await tester.tap(find.byKey(const Key('delete-book')));
    await settle();

    for (final shelf in ['Want to read', 'Reading', 'Done']) {
      await pickShelf(shelf);
      expect(find.text('Piranesi'), findsNothing, reason: 'gone from $shelf');
    }
  });
}
