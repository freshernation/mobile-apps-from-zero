# Day 2 — Notifications: a nudge, and a push

> **By the end of today** Shelf reminds you to read at a time you choose, and a push
> notification sent from the Firebase console opens a specific book when you tap it,
> whether the app was open, in the background, or closed.

There are two kinds of notification, and they're built very differently:

| | **Local** | **Push** |
|---|---|---|
| Who sends it | the app itself, scheduled on the phone | a server, through Firebase Cloud Messaging (FCM) |
| Needs the internet | no | yes |
| Shelf uses it for | the daily reading reminder | "a book you might like", a friend's recommendation… |

The template already does the hard parts: asking permission, getting the push token,
saving it per user, showing pushes while the app is open, and routing taps. Today
you read that code, point it at books, and give the user control over the reminder.

---

## Read first

- [ ] The template's `lib/data/services/notification_service.dart` and
      `lib/routing/notification_router.dart`: every line · 20 min
- [ ] [Firebase Cloud Messaging: receive messages in Flutter](https://firebase.google.com/docs/cloud-messaging/flutter/receive): *Message types* and *Handling interaction* · 15 min
- [ ] [Notification runtime permission (Android 13+)](https://developer.android.com/develop/ui/views/notifications/notification-permission) · 5 min

---

## What you need to know

### Permission, again

Since Android 13, and always on iOS, an app must **ask** before showing
notifications. The template asks once, right after sign-in. If the user says no, the
reminder can't work, and the app should say so instead of silently doing nothing:

```dart
if (!await _notifications.requestPermission()) {
  return const Result.error(PermissionDeniedException());
}
```

The error's message ("Notifications are off for this app. Turn them on in
Settings.") reaches the user through the same SnackBar every Command error uses.

### The reminder, at the user's time

The template schedules a reminder at 9:00. Shelf asks. On the shelf's menu,
**Daily reading reminder** (key `remind-me`) opens Flutter's time picker:

```dart
final time = await showTimePicker(
  context: context,
  initialTime: const TimeOfDay(hour: 21, minute: 0),
);
if (time != null) viewModel.setReminder.execute(time);
```

The picker returns `null` if the user taps Cancel and the time if they tap `OK`.
Only a time schedules anything. (The test taps the picker's own `OK` button.)

`ShelfViewModel.setReminder` (a `Command1<void, TimeOfDay>`) asks permission, then
schedules **every day** at that time with the title `Read for 20 minutes?`. When it
completes, the screen shows `Reminder set`.

Opening the picker is the screen's job, because it's UI. Deciding what to schedule is
the view model's, because that's logic you can test.

### A push that opens a book

A push can carry **data** as well as text. Shelf's convention: a `route` key holding a
path in the app, like `/books/OL893414W`. Tapping the notification opens that path,
through go_router, exactly like tapping a book on the shelf.

A payload comes from outside your app, so treat it like any other input you can't
trust. `NotificationRouter` only follows routes on its **allowlist**; anything else
is ignored:

```dart
static final _allowed = RegExp(r'^/books/[A-Za-z0-9_-]+$');
static bool isAllowed(String route) => route == Routes.home || _allowed.hasMatch(route);
```

The template's allowlist said `/items/`. Change it to `/books/`.

And the book might be gone: deleted yesterday, or on another account. The book
screen already handles a missing book: its `load` fails with `NotFoundException` and
the screen shows `Book not found.` instead of crashing. That's why the error state
from week 4 matters.

### Sending a test push

1. Run Shelf **on a device or emulator signed in to Google Play** (Android), signed in
   to your account. In the debug console, find the line `FCM token: …` and copy it.
2. Firebase console → **Messaging** → **New campaign** → **Notifications** → write a
   title and text → **Send test message** → paste the token.
3. Under **Additional options → Custom data**, add key `route` with value
   `/books/<an id on your shelf>`.
4. Try it three ways: app open, app in the background, app swiped away. Tap each.

**iOS** push needs a paid Apple Developer account (an APNs key uploaded to
Firebase, and the Push Notifications capability in Xcode). The template's README has
the steps. If you don't have an account, Android is enough for the course. Your
instructor will demo iOS.

---

## Exercises

1. `ShelfViewModel.setReminder` and the menu item with the time picker.
2. The `/books/` allowlist.
3. Check that a missing book shows `Book not found.` (the test sends a push for one).

```bash
flutter test test/week_05/day_2_test.dart
```

4. **On a device:** set the reminder two minutes ahead, lock the phone, and wait.
   Then send yourself a test push with a `route` and tap it from all three app states.

---

## Before tomorrow

- [ ] Day 1–2 green; `check.sh` green.
- [ ] **Ship log:** the reminder arriving on a locked phone; a push with a `route`
      opening the book (with the app closed).
- [ ] Signal log. In "hardest thing", explain why the allowlist exists.
