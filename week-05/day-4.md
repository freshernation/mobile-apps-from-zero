# Day 4 — Ship it: icon, splash, release builds, and your capstone plan

> **By the end of today** Shelf has its own icon and launch screen, you've built a
> signed release version that installs like a store download, and you have a
> five-day plan for your own app, signed off by your instructor tomorrow.

Everything so far has been a **debug** build: slow, large, with a DEBUG banner, and
able to hot-reload. Users get **release** builds: compiled ahead of time, fast,
small, and signed with your key. Today you make one, and learn what the stores will
ask for when you're ready to publish.

There are no new tests today. A release build is checked on a device, not in a test.

---

## Read first

- [ ] [Build and release an Android app](https://docs.flutter.dev/deployment/android): *Adding a launcher icon*, *Signing the app*, *Building the app for release* · 25 min
- [ ] [Build and release an iOS app](https://docs.flutter.dev/deployment/ios): *Review Xcode project settings* and *Create a build archive* · 20 min
- [ ] [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons) and [flutter_native_splash](https://pub.dev/packages/flutter_native_splash): README *Usage* sections · 10 min

---

## What you need to know

### The icon and the launch screen

Each platform needs the icon in a dozen sizes, plus Android's "adaptive" shapes.
Don't make them by hand. Make one 1024×1024 PNG (no transparency, since iOS rejects
it), put it at `assets/icon.png`, and let a tool generate the rest:

```bash
flutter pub add --dev flutter_launcher_icons flutter_native_splash
```

```yaml
# pubspec.yaml
flutter_launcher_icons:
  android: true
  ios: true
  image_path: assets/icon.png
  remove_alpha_ios: true

flutter_native_splash:
  color: "#6D4C41"
  image: assets/icon.png
  android_12:
    color: "#6D4C41"
    image: assets/icon.png
```

```bash
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

The **launch screen** (splash) shows while the app starts, before any Dart runs, so it
can't be a Flutter widget. It's native, and the tool writes it for you. Android 12+
always shows your icon on a coloured background. That's why there's an `android_12`
section.

Uninstall the app and install again to see the new icon. Phones cache icons
aggressively.

### Signing on Android

Every Android app is **signed**: a private key proves an update came from the same
developer as the original. Debug builds use a shared debug key. A release for the Play
Store needs **your upload key**:

```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 \
  -validity 10000 -alias upload
```

Keep that file and its passwords **somewhere safe and never in git**. Lose it and you
have to go through Play support to replace it. Leak it and someone else can sign as
you. Then create `android/key.properties` (it's in `.gitignore` already):

```
storePassword=…
keyPassword=…
keyAlias=upload
storeFile=/Users/you/upload-keystore.jks
```

and teach Gradle to use it in `android/app/build.gradle.kts`: read `key.properties`
if it exists, create a `release` signing config from it, and use that for release
builds (falling back to the debug key when the file isn't there, so a fresh clone
still builds). The Flutter docs above have the exact Kotlin.

```bash
flutter build appbundle        # build/app/outputs/bundle/release/app-release.aab — what Play wants
flutter build apk              # an .apk you can install directly to try it
flutter install                # installs the release build on the connected phone
```

Feel the difference: no DEBUG banner, and it starts noticeably faster.

### Release on iOS (on a Mac)

iOS signing is handled by Xcode and your Apple account:

1. `open ios/Runner.xcworkspace`, select **Runner** → **Signing & Capabilities**, and
   choose your team. A free Apple ID can install to your own phone for 7 days. The
   App Store needs the paid program.
2. `flutter build ipa` builds the archive. With a paid account, Xcode's
   **Organizer** uploads it to TestFlight.

### Publishing: what's left, and why it's not required

The Play Console and App Store Connect will ask for: a privacy policy URL, screenshots,
a description, content ratings, and (on Play) a closed test with real testers before
your first public release. Review can take hours or days, and it isn't something you
control. That's why publishing isn't required in this course. Everything up to the
upload is.

### Your capstone plan

Next week you build **your own app** from the template, in five days. Today you plan
it with `ai/planner.md`. It asks you questions and helps you cut scope until the plan
fits five days. You end with `CAPSTONE.md` in your capstone folder:

- **The app in one sentence**, and who it's for.
- **The model**: your `Book`. One or two classes, with fields.
- **Three core screens**, sketched (paper is fine; photograph it).
- **What it does on day 5**: the demo, step by step.
- **What you're not building**: write it down, so you don't drift into it on
  Wednesday.

Tomorrow your instructor signs it off or cuts it. Stuck for an idea? Your instructor
has a list.

---

## Exercises

1. Icon and launch screen for Shelf.
2. An upload key, `key.properties`, the Gradle signing config, and
   `flutter build appbundle`.
3. Install the release APK (`flutter build apk && flutter install`). On a Mac, also
   archive for iOS.
4. `CAPSTONE.md` with `ai/planner.md`.

---

## Before tomorrow

- [ ] `check.sh` green, all of weeks 4–5.
- [ ] **Ship log:** your icon on the home screen; the launch screen; the release build
      running (no DEBUG banner); the size of `app-release.aab`.
- [ ] `CAPSTONE.md` written.
- [ ] Read `week-05/DEFEND.md`. Tomorrow is Project 3.
