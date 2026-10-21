# Day 1 — The template: nothing in it is new

> **By the end of today** you have `shelf_v2/`, your own copy of the course's app
> template, renamed to Shelf, running on your device. You can point to where
> everything you built by hand last week lives in it.

For three weeks you built every piece by hand: models, repositories, `Result`,
`Command`, view models, routing, tests. That was the point. Starting today you get a
**template**: a standard starting point with all of those pieces already wired
together, plus things that take a week each to get right (accounts, three
backends, notifications). From now on, every app you start, starts here.

You'll find that you can read every file. That's what weeks 1–3 bought you.

---

## The rule changes today

Weeks 1–3: you wrote every line. From today, **AI may write code with you**, with one
rule in its place:

> **You may not commit a line you could not have written and cannot explain on Friday.**

Use `ai/editor.md` to review what you (or the AI) wrote, and `ai/tutor.md` when you
don't understand something. Friday's defense will point at lines at random.

---

## Read first

- [ ] The template's `README.md`: all of it · 15 min
- [ ] Your own `week-03/README.md`: the table *You just built the template* · 5 min
- [ ] [Guide to app architecture: Recommendations](https://docs.flutter.dev/app-architecture/recommendations) · 15 min. The template follows this page; you'll recognise every row.

---

## What you need to know

### Get your copy

The template lives at [github.com/freshernation/mobile-app-template](https://github.com/freshernation/mobile-app-template). Put your
copy next to `shelf/` in this course repo:

```bash
git clone https://github.com/freshernation/mobile-app-template.git shelf_v2
rm -rf shelf_v2/.git          # it's your app now, not a copy of theirs
cd shelf_v2
flutter pub get
```

### Run it before you change anything

The template's REST backend comes with a small local server, so it runs with no
account at all:

```bash
dart run tool/dev_server.dart          # terminal 1 — leave it running
flutter run -t lib/main_rest.dart      # terminal 2
```

Create an account, add an item, tick it, delete it. This is the template's example
feature, **items**. Over the next three days it becomes your books.

### Rename it in one command

```bash
dart run tool/rename.dart shelf_v2 dev.yourname.shelf "Shelf"
flutter pub get
```

That changes the Dart package name (every `import 'package:…'`), the Android app id,
the iOS bundle id, and the name under the icon. Use your own name in the id: two
apps on the stores can never share one.

Then set Shelf's colour: `seedColor` in `lib/ui/core/theme.dart` →
`Color(0xFF6D4C41)`. Every other colour, light and dark, follows from it.

### The two scripts you'll run all week

```bash
bash tool/check.sh     # formatting, lints and every test: green before every commit
```

and the course's tests, which you copy in **one day at a time**:

```bash
mkdir -p test/week_04
cp ../week-04/tests/day_1_test.dart test/week_04/
flutter test test/week_04
```

Why not all of them at once? Day 3's and day 4's tests import files you haven't
written yet (`book.dart`, `book_repository.dart`…). Copied today, they'd turn
`check.sh` red for three days for no reason. Each day's lesson tells you which files
to copy.

### The tour

Open the template next to your Shelf (`shelf/`). For each row of the table in
`week-03/README.md`, open the template's file and find the part you wrote yourself.
Then look at what's new and read it in this order:

1. `lib/main_rest.dart` → `lib/config/dependencies_rest.dart`: where the pieces are
   wired together. One file per backend.
2. `lib/app.dart` → `lib/routing/router.dart`: the redirect that sends signed-out
   users to sign-in, and `_page(...)`, which you met as the search route's
   `ChangeNotifierProvider(create: …)` in week 3.
3. `lib/data/repositories/auth/`: the same idea as `BookRepository`, for accounts.
   Three implementations, one interface.
4. `test/contracts/`: one set of tests every backend must pass. This is week 3 day 4's
   "same promises, new implementation", made into code.

---

## Exercises

1. Clone, run on REST, rename, recolour (above).
2. Copy in today's test. `flutter test test/week_04/day_1_test.dart` should be
   green.
3. `bash tool/check.sh`: green.
4. **The map, in your own words.** Create `shelf_v2/NOTES.md`. For each row of the
   week 3 table, write one sentence: what the template's version does that yours
   didn't, or "same". This is Friday's first defense question.

---

## Before tomorrow

- [ ] **Ship log:** the renamed app, showing "Shelf" under its icon, on a device.
- [ ] Signal log. In "hardest thing", name the one template file you understand least.
- [ ] Tomorrow needs a Google account for Firebase. Make sure you can sign in at
      [console.firebase.google.com](https://console.firebase.google.com).
