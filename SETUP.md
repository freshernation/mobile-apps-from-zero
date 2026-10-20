# Setup

Do all of this **before day 1**. It takes one to three hours, mostly downloads. When
you're done, `flutter doctor` is green and the starter app runs on an emulator.

If you get stuck, note exactly which step and the exact error, and bring it to your
instructor before the course starts. Don't wait for Monday.

---

## What you need

| | Minimum | Recommended |
|---|---|---|
| **Computer** | Windows 10+, macOS 14+, or Linux (64-bit) | — |
| **Memory** | 8 GB RAM | 16 GB: the Android emulator is hungry |
| **Disk** | 30 GB free | 50 GB: Android SDK, emulator images, Xcode and build output add up fast |
| **For iOS** | — | A Mac with Xcode. Without one you do everything on Android, and iOS is taught but not required. |
| **A phone** | — | An Android phone and its USB cable. Weeks 5–6 need a real device for the camera, notifications and release builds. |
| **Accounts** | A Google account (Firebase, week 4) | Apple Developer Program ($99/yr), *only* for iOS push and App Store builds. Not required. |

Slow computer? A physical Android phone over USB is an accepted alternative to the
emulator, and often faster.

---

## 1. Flutter 3.47.7

The course is pinned to **Flutter 3.47.7** (Dart 3.13.5). Other versions mostly work,
but tests and lessons are checked against this one.

Follow the official guide for your system, choosing **Android** as the target (and
**iOS** too on a Mac): [Install Flutter](https://docs.flutter.dev/get-started/install).

Then check the version:

```bash
flutter --version          # Flutter 3.47.7 • channel stable
```

If you already had Flutter, `flutter upgrade` brings you to the latest stable. If
that's newer than 3.47.7, tell your instructor which version you're on.

## 2. An editor: VS Code

Install [VS Code](https://code.visualstudio.com/) and the **Flutter** extension (it
installs the Dart one too). Android Studio works as well, but lessons use VS Code
names.

## 3. Android

1. Install [Android Studio](https://developer.android.com/studio). You need its SDK
   and emulator, even if you write code in VS Code.
2. In Android Studio: **More Actions → SDK Manager**. Install the latest **Android SDK
   Platform**, **Android SDK Command-line Tools**, **Android SDK Build-Tools** and
   **Android Emulator**.
3. Accept the licences:
   ```bash
   flutter doctor --android-licenses
   ```
   Answer `y` to each.
4. **More Actions → Virtual Device Manager → Create device.** Pick a Pixel, and on the
   system image screen choose one whose name says **Google Play**. You need Google
   Play services for push notifications in week 5.

## 4. iOS (Mac only)

1. Install **Xcode** from the Mac App Store, then open it once and let it install its
   components.
2. ```bash
   sudo xcodebuild -license accept
   xcodebuild -downloadPlatform iOS
   ```
3. `open -a Simulator` should show an iPhone.

## 5. git

You probably have it: `git --version`. If not: [git-scm.com](https://git-scm.com/downloads).
Then set your name and email, as `git config --global user.name "…"` and
`git config --global user.email "…"`.

## 6. Node.js (needed in week 4)

Firebase's command-line tool runs on Node. Install the LTS version from
[nodejs.org](https://nodejs.org/) and check `npm --version`. You'll install the
Firebase tools themselves in week 4.

---

## 7. Check: `flutter doctor`

```bash
flutter doctor
```

You need ticks on **Flutter**, **Android toolchain**, and (on a Mac) **Xcode**. Chrome,
other IDEs and "Network resources" warnings don't matter for this course.

## 8. Check: run the starter app

From this repository:

```bash
cd shelf
flutter pub get
flutter emulators --launch <your emulator's name>   # `flutter emulators` lists them
flutter run
```

The Flutter counter app appears. Tap the button and the number goes up. That's day
1's starting point. On a Mac, also try `open -a Simulator` then `flutter run` and pick
the iPhone.

Then run the tests once, to see what "every test fails before you start" looks like:

```bash
flutter test test/week_01/day_1_test.dart
```

Red is correct. That's the starting line.

---

## When it goes wrong

| What you see | Fix |
|---|---|
| `Android license status unknown` | `flutter doctor --android-licenses`, then `y` to each |
| `cmdline-tools component is missing` | SDK Manager → SDK Tools → Android SDK Command-line Tools |
| Emulator won't start, or is unbearably slow | Enable virtualisation in your BIOS (Windows/Linux); close other apps; or use a physical phone over USB (Developer options → USB debugging) |
| `Unable to locate a Java Runtime` or Gradle errors about Java | Use the Java that ships with Android Studio: `flutter config --jdk-dir "<Android Studio's jbr folder>"` |
| Xcode: `CocoaPods not installed` or license errors | `sudo xcodebuild -license accept`; open Xcode once. Recent Flutter uses Swift Package Manager, so CocoaPods is rarely needed. |
| `flutter` not found after installing | Its `bin` folder isn't on your PATH. The install guide's "Update your path" step |
| A first build sits on "Running Gradle task" for a long time | Normal the first time: it's downloading. Later builds are much faster. |

Write down anything you hit in [logs/stuck-log.md](logs/stuck-log.md). Your
instructor uses it to fix this page for the next cohort.
