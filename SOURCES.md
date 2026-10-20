# Sources

Everything the course asks you to read, by week. All official documentation: the
Flutter and Dart teams, Firebase, Android, Apple, and the packages' own pages. When a
lesson and a source disagree, the source is more likely to be current; tell your
instructor.

**Versions:** Flutter 3.47.7, Dart 3.13.5. Packages are pinned in each project's
`pubspec.yaml`.

---

## Week 1 — Dart, and your first screen

- [Install Flutter](https://docs.flutter.dev/get-started/install)
- [A tour of the Dart language](https://dart.dev/language)
- [Understanding null safety](https://dart.dev/null-safety/understanding-null-safety)
- [Classes](https://dart.dev/language/classes) · [Constructors](https://dart.dev/language/constructors) · [Enums](https://dart.dev/language/enums)
- [Asynchronous programming: futures, async, await](https://dart.dev/libraries/async/async-await)
- [Error handling](https://dart.dev/language/error-handling)
- [Asynchronous programming: Streams](https://dart.dev/libraries/async/using-streams)
- [Building user interfaces with Flutter](https://docs.flutter.dev/ui)
- [Layouts in Flutter](https://docs.flutter.dev/ui/layout)
- [Widget catalog](https://docs.flutter.dev/ui/widgets): keep it open all course

## Week 2 — Interactive, and more than one screen

- [Adding interactivity to your Flutter app](https://docs.flutter.dev/ui/interactivity)
- [`StatefulWidget`](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html)
- [Work with long lists](https://docs.flutter.dev/cookbook/lists/long-lists) · [`ListTile`](https://api.flutter.dev/flutter/material/ListTile-class.html) · [`Expanded`](https://api.flutter.dev/flutter/widgets/Expanded-class.html)
- [Build a form with validation](https://docs.flutter.dev/cookbook/forms/validation) · [Retrieve the value of a text field](https://docs.flutter.dev/cookbook/forms/retrieve-input) · [Handle changes to a text field](https://docs.flutter.dev/cookbook/forms/text-field-changes)
- [Navigation and routing](https://docs.flutter.dev/ui/navigation)
- [go_router: Get started](https://pub.dev/documentation/go_router/latest/topics/Get%20started-topic.html) · [go_router: Navigation](https://pub.dev/documentation/go_router/latest/topics/Navigation-topic.html)
- [Use themes to share colors and font styles](https://docs.flutter.dev/cookbook/design/themes)

## Week 3 — Architecture, by hand

The architecture you build here, and the template's, follows Flutter's own guide:

- [Guide to app architecture: Concepts](https://docs.flutter.dev/app-architecture/concepts)
- [UI layer](https://docs.flutter.dev/app-architecture/case-study/ui-layer) · [Data layer](https://docs.flutter.dev/app-architecture/case-study/data-layer)
- [Result objects](https://docs.flutter.dev/app-architecture/design-patterns/result) · [The command pattern](https://docs.flutter.dev/app-architecture/design-patterns/command)
- [Simple app state management](https://docs.flutter.dev/data-and-backend/state-mgmt/simple) (`ChangeNotifier`, `provider`)
- [Fetch data from the internet](https://docs.flutter.dev/cookbook/networking/fetch-data)
- [JSON and serialization](https://docs.flutter.dev/data-and-backend/serialization/json)
- [Open Library Search API](https://openlibrary.org/dev/docs/api/search)
- [Persist data with SQLite](https://docs.flutter.dev/cookbook/persistence/sqlite) · [sqflite](https://pub.dev/packages/sqflite)
- [Offline-first support](https://docs.flutter.dev/app-architecture/design-patterns/offline-first)

## Week 4 — The template, and the cloud

- [Guide to app architecture: Recommendations](https://docs.flutter.dev/app-architecture/recommendations)
- [Add Firebase to your Flutter app](https://firebase.google.com/docs/flutter/setup)
- [Get started with Firebase Authentication on Flutter](https://firebase.google.com/docs/auth/flutter/start)
- [Cloud Firestore data model](https://firebase.google.com/docs/firestore/data-model)
- [Get started with Cloud Firestore Security Rules](https://firebase.google.com/docs/firestore/security/get-started)
- [Access data offline](https://firebase.google.com/docs/firestore/manage-data/enable-offline)

## Week 5 — Real-device work

- [mobile_scanner](https://pub.dev/packages/mobile_scanner)
- [App permissions on Android](https://developer.android.com/guide/topics/permissions/overview) · [Requesting access to protected resources (iOS)](https://developer.apple.com/documentation/uikit/requesting-access-to-protected-resources)
- [ISBN](https://en.wikipedia.org/wiki/ISBN): check digits
- [Firebase Cloud Messaging: receive messages in Flutter](https://firebase.google.com/docs/cloud-messaging/flutter/receive)
- [Notification runtime permission (Android 13+)](https://developer.android.com/develop/ui/views/notifications/notification-permission)
- [Accessibility](https://docs.flutter.dev/ui/accessibility-and-internationalization/accessibility)
- [Automatic platform adaptations](https://docs.flutter.dev/ui/adaptive-responsive/platform-adaptations) · [`AlertDialog.adaptive`](https://api.flutter.dev/flutter/material/AlertDialog/AlertDialog.adaptive.html)
- [Build and release an Android app](https://docs.flutter.dev/deployment/android) · [Build and release an iOS app](https://docs.flutter.dev/deployment/ios)
- [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons) · [flutter_native_splash](https://pub.dev/packages/flutter_native_splash)

## Week 6 — Your app

Nothing new to read. Everything above is your reference, plus your own Shelf v2.
For whatever your app needs that Shelf didn't, start from:

- [Flutter cookbook](https://docs.flutter.dev/cookbook): short, official recipes
- [pub.dev](https://pub.dev): check a package's **likes**, **pub points**, **last
  published** date and **platforms** before you add it
