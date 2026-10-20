# Day 1 — Your toolchain, and enough Dart to start

> **By the end of today** an app you didn't write is running on your emulator, you've
> changed it with hot reload, and you've written six small Dart functions that pass
> their tests.

You've written some code before, so most of today will look familiar. Dart has
variables, functions, `if`, loops and lists like every language you've seen. Two
things are new and matter all course: **types** and **null safety**. We start on
types today and go deep on null safety tomorrow.

The first hour is not code at all. It's getting the toolchain green. Expect friction
here, because everyone hits some. That's what the live hour is for.

---

## Read first

- [ ] [Install Flutter](https://docs.flutter.dev/get-started/install): pick your OS and **Android** as the target. If you're on a Mac, do **iOS** as well · 45 min, mostly waiting
- [ ] [A tour of the Dart language](https://dart.dev/language): read *Variables*, *Built-in types* (numbers, strings, lists, maps) and *Functions* only · 25 min

If you did `SETUP.md` before the course, the install is already done. Run
`flutter doctor` to confirm.

---

## What you need to know

### `flutter doctor` is your first test

```bash
flutter doctor
```

Every line should be a green tick for **Flutter**, **Android toolchain** and (on a
Mac) **Xcode**. Chrome and other IDEs don't matter for this course. When something is
red, the message tells you the exact command to fix it, so read it before you search.

The two most common reds:

| Red line | Fix |
|---|---|
| Android license status unknown | `flutter doctor --android-licenses`, then answer `y` to each |
| Xcode: CocoaPods / license | `sudo xcodebuild -license accept`, then open Xcode once |

### Run something you didn't write

`shelf/` in this repo is a brand-new Flutter project, the counter app that
`flutter create` makes. You'll turn it into Shelf over three weeks.

```bash
cd shelf
flutter emulators --launch <name>   # or start one from Android Studio's Device Manager
flutter run
```

On a Mac, also try `open -a Simulator`, then `flutter run` and pick the iPhone.

With the app running, open `lib/main.dart`. Change `'Flutter Demo Home Page'` to
your name and save. The app updates in about a second, and the counter keeps its
number. That's **hot reload**: your code changes, your app's state stays. Press `R`
in the terminal for **hot restart**, which rebuilds from scratch and resets the
counter. You'll use hot reload hundreds of times a day.

### Dart: types you can see

```dart
var title = 'Dune';          // Dart works out the type: String
int pages = 412;             // or you write it
final author = 'Herbert';    // set once, never reassigned
const pagesPerHour = 40;     // known before the program even runs

title = 'Emma';              // fine: var can change
author = 'Austen';           // error: final can't be reassigned
pages = 'lots';              // error: pages is an int
```

The last two lines don't run. They don't even **compile**: the editor underlines
them in red as you type. That's the point of types. A whole class of bugs is caught
before you press run.

Use `final` by default and `var` only when the value really changes. Use `const`
for values fixed at compile time. You'll see `const` a lot in Flutter, because it
lets Flutter skip rebuilding things that can't change.

### Collections

```dart
final pageCounts = <int>[320, 180, 500];   // a List<int>
pageCounts.add(90);
pageCounts.length;                          // 4
pageCounts.first;                           // 320

final ratings = <String, int>{'Dune': 5};   // a Map<String, int>
ratings['Emma'] = 4;
ratings['Dune'];                            // 5
ratings['Ulysses'];                         // null: not in the map
```

That last `null` matters tomorrow. For now, note that asking a map for a missing key
doesn't crash. It gives you "nothing". When you want a fallback instead, `??` means
"or this, if it's null":

```dart
ratings['Ulysses'] ?? 0;     // 0
```

### Functions

```dart
int twice(int n) {
  return n * 2;
}

int thrice(int n) => n * 3;        // one expression? use =>

String label(String title, {int stars = 0}) => '$title ($stars★)';

label('Dune');                     // 'Dune (0★)'
label('Dune', stars: 5);           // 'Dune (5★)'
```

`{int stars = 0}` is a **named parameter** with a default. Flutter uses named
parameters everywhere (`Text('hi', style: …)`), so get used to reading them.

`'$title'` and `'${a + b}'` are **string interpolation**: the variable or expression
is put straight into the string.

### Loops, and the shorter way

```dart
var total = 0;
for (final pages in pageCounts) {
  total += pages;
}

final long = titles.where((t) => t.length > 6).toList();
```

`where` keeps the items for which the function returns true. `(t) => t.length > 6`
is a function with no name, written inline. You'll pass functions like this all day
in Flutter: every button's `onPressed` is one.

### Division

```dart
7 / 2      // 3.5   — always a double
7 ~/ 2     // 3     — whole-number division
(7 / 2).ceil()   // 4 — round up
```

---

## Exercises

Open `shelf/lib/exercises/day_1.dart`. It has six functions, each with a comment
saying what it should do and a body that throws `UnimplementedError`. Do them in
order, and run the tests after each one:

```bash
cd shelf
flutter test test/week_01/day_1_test.dart
```

Every test fails before you start. That's the starting line, not a problem.

1. `greet`: watch the blank-name case.
2. `totalPages`: write it with a `for` loop.
3. `averagePages`: what does `0 / 0` give in Dart? Try it, then make sure an empty
   list returns `0`.
4. `longTitles`: use `where`.
5. `booksPerAuthor`: `counts[author]` is `null` the first time you see an author.
   What do you add `1` to?
6. `hoursToRead`: 100 pages at 40 an hour is 2.5 hours. The test wants `3`.

**AI is off for writing code this week and the next two.** If you're stuck for 20
minutes, open `ai/tutor.md` (it asks you questions, it doesn't write the answer), log
it in `logs/stuck-log.md`, and bring it to the live hour. The point of these three
weeks is that you wrote every line of Shelf yourself.

---

## Before tomorrow

- [ ] All 16 tests green.
- [ ] **Ship log:** add a row to `logs/ship-log.md` with a screenshot of the counter app
      on your emulator, showing your name in the title (hot reload, not restart).
- [ ] **Signal log:** add today's row to `logs/signal-log.md`. Under "hardest thing",
      say which exercise you got wrong first, and why.
