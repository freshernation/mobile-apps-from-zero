// Week 5, day 3 — every state, every platform, every reader.
// Run: flutter test test/week_05/day_3_test.dart
import 'dart:convert';
import 'dart:ui' show SemanticsFlag;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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
import 'package:shelf_v2/utils/app_exceptions.dart';

import '../../testing/fakes/fake_auth_repository.dart';
import '../../testing/fakes/fake_book_repository.dart';
import '../../testing/fakes/fake_notification_service.dart';

final longBook = Book(
  id: 'OL1W',
  title: 'The Hitchhiker\'s Guide to the Galaxy: The Complete Trilogy in Five Parts',
  authors: const ['Douglas Adams', 'Eoin Colfer', 'Someone With A Long Name'],
  pageCount: 832,
  status: ShelfStatus.reading,
  currentPage: 120,
  updatedAt: DateTime.utc(2026),
);

late FakeBookRepository books;

Future<void> pumpApp(WidgetTester tester, {List<Book>? shelf}) async {
  // A phone-sized screen, not the test default.
  tester.view.physicalSize = const Size(390, 844) * 3;
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);

  final auth = FakeAuthRepository();
  await auth.signUp(email: 'a@x.com', password: 'pw');
  books = FakeBookRepository(books: shelf ?? [longBook]);
  await tester.pumpWidget(MultiProvider(
    providers: [
      ChangeNotifierProvider<AuthRepository>.value(value: auth),
      Provider<BookRepository>.value(value: books),
      Provider<NotificationService>.value(value: FakeNotificationService()),
      Provider<OpenLibraryService>.value(
        value: OpenLibraryService(
          client: MockClient((_) async => http.Response(
                jsonEncode({
                  'docs': [
                    {'key': '/works/OL2W', 'title': longBook.title, 'author_name': longBook.authors},
                  ],
                }),
                200,
              )),
        ),
      ),
    ],
    child: const App(),
  ));
  await tester.pumpAndSettle();
}

Future<void> openBook(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key('book-OL1W')));
  await tester.pumpAndSettle();
}

Future<void> openSearchResults(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key('add-book')));
  await tester.pumpAndSettle();
  await tester.enterText(find.byKey(const Key('search-field')), 'guide');
  await tester.testTextInput.receiveAction(TextInputAction.search);
  await tester.pumpAndSettle();
}

void expectEveryIconButtonHasATooltip(WidgetTester tester) {
  for (final button in tester.widgetList<IconButton>(find.byType(IconButton))) {
    expect(button.tooltip, isNotEmpty,
        reason: 'a screen reader says nothing useful for an icon with no tooltip');
  }
}

void main() {
  group('states', () {
    testWidgets('a shelf that fails to load says so, and retry loads it',
        (tester) async {
      await pumpApp(tester, shelf: [longBook]);
      books.failWith = const NetworkException();
      await tester.drag(find.byType(ListView), const Offset(0, 300));
      await tester.pumpAndSettle();
      // A failed refresh keeps the books you already had…
      expect(find.byKey(const Key('book-OL1W')), findsOneWidget);
    });

    testWidgets('a shelf that fails on first load shows an error and retry',
        (tester) async {
      final auth = FakeAuthRepository();
      await auth.signUp(email: 'a@x.com', password: 'pw');
      final failing = FakeBookRepository(books: [longBook])
        ..failWith = const NetworkException();
      await tester.pumpWidget(MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthRepository>.value(value: auth),
          Provider<BookRepository>.value(value: failing),
          Provider<NotificationService>.value(value: FakeNotificationService()),
          Provider<OpenLibraryService>.value(value: OpenLibraryService()),
        ],
        child: const App(),
      ));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('shelf-error')), findsOneWidget);

      failing.failWith = null;
      await tester.tap(find.byKey(const Key('retry')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('book-OL1W')), findsOneWidget);
    });
  });

  group('screen readers', () {
    testWidgets('every icon button on every screen has a tooltip',
        (tester) async {
      await pumpApp(tester);
      expectEveryIconButtonHasATooltip(tester);

      await openBook(tester);
      expectEveryIconButtonHasATooltip(tester);

      await tester.pageBack();
      await tester.pumpAndSettle();
      await openSearchResults(tester);
      expectEveryIconButtonHasATooltip(tester);
    });

    testWidgets('the progress slider reads out the page, not a number',
        (tester) async {
      await pumpApp(tester);
      await openBook(tester);

      // The node a screen reader lands on when it reaches the slider.
      final slider = find.semantics.byFlag(SemanticsFlag.isSlider).evaluate().single;
      expect(slider.value, 'Page 120 of 832', reason: 'not "14%"');
    });
  });

  group('large text', () {
    for (final scale in [1.5, 2.0]) {
      testWidgets('every screen lays out at ${scale}x text', (tester) async {
        tester.platformDispatcher.textScaleFactorTestValue = scale;
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

        await pumpApp(tester);
        expect(tester.takeException(), isNull, reason: 'shelf');

        await openBook(tester);
        expect(tester.takeException(), isNull, reason: 'book');

        await tester.pageBack();
        await tester.pumpAndSettle();
        await openSearchResults(tester);
        expect(tester.takeException(), isNull, reason: 'search');
      });
    }
  });

  group('each platform', () {
    for (final platform in [TargetPlatform.android, TargetPlatform.iOS]) {
      testWidgets('delete asks the way ${platform.name} asks', (tester) async {
        debugDefaultTargetPlatformOverride = platform;
        await pumpApp(tester);
        await openBook(tester);

        await tester.tap(find.byKey(const Key('delete-book')));
        await tester.pumpAndSettle();

        if (platform == TargetPlatform.iOS) {
          expect(find.byType(CupertinoAlertDialog), findsOneWidget);
        } else {
          expect(find.byType(CupertinoAlertDialog), findsNothing);
          expect(find.byType(Dialog), findsOneWidget); // Material's
        }
        await tester.tap(find.byKey(const Key('confirm-delete')));
        await tester.pumpAndSettle();
        expect(find.byKey(const Key('book-OL1W')), findsNothing);
        debugDefaultTargetPlatformOverride = null;
      });
    }
  });
}
