// Week 5, day 2 — notifications. Run: flutter test test/week_05/day_2_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shelf_v2/app.dart';
import 'package:shelf_v2/data/repositories/auth/auth_repository.dart';
import 'package:shelf_v2/data/repositories/books/book_repository.dart';
import 'package:shelf_v2/data/services/notification_service.dart';
import 'package:shelf_v2/data/services/open_library_service.dart';
import 'package:shelf_v2/domain/models/book.dart';
import 'package:shelf_v2/routing/notification_router.dart';
import 'package:shelf_v2/ui/books/shelf_view_model.dart';
import 'package:shelf_v2/utils/app_exceptions.dart';
import 'package:shelf_v2/utils/result.dart';

import '../../testing/fakes/fake_auth_repository.dart';
import '../../testing/fakes/fake_book_repository.dart';
import '../../testing/fakes/fake_notification_service.dart';

void main() {
  group('the reading reminder', () {
    test('is scheduled every day at the time you pick', () async {
      final notifications = FakeNotificationService();
      final shelf = ShelfViewModel(
        books: FakeBookRepository(),
        auth: FakeAuthRepository(),
        notifications: notifications,
      );

      await shelf.setReminder.execute(const TimeOfDay(hour: 21, minute: 30));

      final reminder = notifications.scheduled.single;
      expect((reminder.hour, reminder.minute), (21, 30));
      expect(reminder.title, 'Read for 20 minutes?');
      shelf.dispose();
    });

    test('without permission, nothing is scheduled and you are told why',
        () async {
      final notifications = FakeNotificationService()..permissionGranted = false;
      final shelf = ShelfViewModel(
        books: FakeBookRepository(),
        auth: FakeAuthRepository(),
        notifications: notifications,
      );

      await shelf.setReminder.execute(const TimeOfDay(hour: 21, minute: 0));

      expect(notifications.scheduled, isEmpty);
      expect((shelf.setReminder.result as Error).error,
          isA<PermissionDeniedException>());
      shelf.dispose();
    });
  });

  group('push routes', () {
    test('a book can be opened from a notification', () {
      expect(NotificationRouter.isAllowed('/books/OL893414W'), isTrue);
      expect(NotificationRouter.isAllowed('/'), isTrue);
    });

    test('anything else is ignored', () {
      for (final route in ['/items/1', '/admin', '/books/../admin', 'https://x.y', '']) {
        expect(NotificationRouter.isAllowed(route), isFalse, reason: route);
      }
    });
  });

  group('in the app', () {
    late FakeNotificationService notifications;

    Future<void> pumpApp(WidgetTester tester, List<Book> books) async {
      final auth = FakeAuthRepository();
      await auth.signUp(email: 'a@x.com', password: 'pw');
      notifications = FakeNotificationService();
      await tester.pumpWidget(MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthRepository>.value(value: auth),
          Provider<BookRepository>.value(value: FakeBookRepository(books: books)),
          Provider<NotificationService>.value(value: notifications),
          Provider<OpenLibraryService>.value(value: OpenLibraryService()),
        ],
        child: const App(),
      ));
      await tester.pumpAndSettle();
    }

    testWidgets('the menu sets the reminder with a time picker', (tester) async {
      await pumpApp(tester, []);

      await tester.tap(find.byKey(const Key('menu')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('remind-me')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(notifications.scheduled, hasLength(1));
      expect(find.text('Reminder set'), findsOneWidget);
    });

    testWidgets('tapping a push for a book opens it', (tester) async {
      await pumpApp(tester, [
        Book(id: 'OL1W', title: 'Dune', updatedAt: DateTime.utc(2026)),
      ]);

      notifications.taps.add('/books/OL1W');
      await tester.pumpAndSettle();

      expect(
        tester.widget<Text>(find.byKey(const Key('book-title'))).data,
        'Dune',
      );
    });

    testWidgets('a push for a deleted book says so, and does not crash',
        (tester) async {
      await pumpApp(tester, []);

      notifications.taps.add('/books/gone');
      await tester.pumpAndSettle();

      expect(find.text('Book not found.'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
