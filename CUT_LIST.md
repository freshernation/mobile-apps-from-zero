# Cut list

What this course deliberately doesn't teach, and why. Six weeks is enough to build
and ship an app of your own **if** the course says no to a lot. Each of these is
worth learning, just not here, and not before you can build without help.

| Cut | Why | When you'll want it |
|---|---|---|
| **Riverpod, Bloc, and other state-management libraries** | The course follows Flutter's own architecture guide: `ChangeNotifier` view models, `provider` for wiring. One pattern, learned properly, beats four learned halfway. The ideas (state, commands, separating UI from data) carry straight over. | When you join a team that uses one. You'll learn it in days, because you'll recognise what it's doing. |
| **`freezed` and code generation** | You write models by hand in week 1 (`copyWith`, `==`, JSON) so you know what generated code does. The template keeps them hand-written so nothing is magic. | When a model gets past ten fields, or you have dozens of them. |
| **Custom and implicit animation** | Material's built-in transitions are good, and animation done badly is worse than none. | After your first app ships: the [animation docs](https://docs.flutter.dev/ui/animations) are excellent. |
| **Platform channels and native code** | Every feature in the course has a plugin. Writing Kotlin or Swift is a course of its own. | When you need something no plugin does: a specific SDK, a sensor. |
| **Web and desktop targets** | Flutter can build them, but phones are the point, and each target has its own layout and platform work. | When your app needs to be on a laptop too. The architecture you learned doesn't change. |
| **CI/CD** | `tool/check.sh` is your pipeline for now. Automating it is a configuration exercise, not a Flutter one. | Your second app, or the first one more than one person works on. |
| **In-app purchases and payments** | Store accounts, tax setup and review rules make it a project of its own. | When your app has something to sell. |
| **Server-triggered push** (Cloud Functions or your own server) | You learn to *receive* and route push. Sending it on events needs a backend (and Firebase's paid Blaze plan for Functions). The console's test message is enough to prove the app side. | When your app has something worth telling users about without them opening it. |
| **Localisation** | Every string is already in `AppStrings`, one file, which is the hard part done. Translating it is mechanical. | When your users don't all read English. See [internationalization](https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization). |
| **Supabase, beyond reading it** | The template supports it, and in week 4 you read its implementation next to Firebase's to see one interface done three ways. Building on two cloud backends in one course halves the depth of both. | When you'd rather have Postgres and SQL than Firestore. Your template already has it. |
| **Publishing to the stores** | Every step up to the upload is taught, and a release build on your phone is required. (On iOS, archiving for the App Store needs the paid Apple program, so it's taught but optional.) Store review takes hours to days and isn't something you control, so it can't be a pass condition for a six-week course. | When your capstone is ready. Week 5 day 4 lists exactly what each store will ask for. |

If you find yourself needing one of these during the capstone, that's the signal to
cut the feature, not to learn the tool. It goes in your README under "what I'd build
next".
