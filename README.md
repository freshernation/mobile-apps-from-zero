# Mobile Apps From Zero

Six weeks from "I've written a little code" to an app of your own, on Android and
iOS, built with Flutter, that you can explain line by line and would show anyone.

You need to have written *some* code (a little Python or JavaScript, a tutorial or
two) and to have never built an app. You don't need a Mac (Android is the core path;
a Mac adds iOS). You do need about four hours a day.

Everything here aims at one outcome: **in week 6 you build your own app, from the
course's template, in five days, and defend it live:** demo it, explain any line
your instructor points at, and change it on the spot. If something looks missing, it
was cut on purpose. See [CUT_LIST.md](CUT_LIST.md).

---

## The three rules

**1. The twenty-minute rule.**
Stuck? Struggle alone for twenty minutes. Then open the **tutor**
([ai/tutor.md](ai/tutor.md)), never a plain chat, and never "write this for me". Then,
and only then, bring it to the live hour. Log every stuck moment in
[logs/stuck-log.md](logs/stuck-log.md).

**2. Weeks 1–3, you write every line.**
AI is a tutor, not an author, while you build Shelf by hand. Not a moral position:
the template you get in week 4 is made of exactly the pieces you'll have written, and
the whole value of these three weeks is that you wrote them. From week 4 the AI may
write code with you, and the rule that replaces this one is:
**you may not commit a line you could not have written and cannot explain on Friday.**

**3. Nothing counts until the tests pass, it ran on a device, and it's pushed.**
A test proves behaviour. A phone proves the rest. Device runs go in
[logs/ship-log.md](logs/ship-log.md), with a screenshot or a recording.

---

## The six weeks

| Week | | Milestone |
|---|---|---|
| 1 | [Dart, and your first screen](week-01/README.md) | Shelf's book screen, built from a model you wrote, on your phone |
| 2 | [Interactive, and more than one screen](week-02/README.md) | **Project 1**: Shelf works, in memory, across every screen |
| 3 | [Architecture, by hand](week-03/README.md) | **Project 2**: Shelf in layers, with real search and saved on the phone |
| 4 | [The template, and the cloud](week-04/README.md) | Shelf v2 on the template: accounts and sync on Firebase |
| 5 | [Real-device work](week-05/README.md) | **Project 3**: camera scanning, notifications, accessibility, a signed release build |
| 6 | [Your app](week-06/README.md) | **Capstone**: your own app, built in five days, defended live |

Two acts:

```
BUILD IT BY HAND   week 1   Dart, a model, one screen
                   week 2   state, lists, forms, navigation — and why it hurts
                   week 3   repository, view model, HTTP, SQLite — the cure        <- keystone

BUILD IT FAST      week 4   the template: everything from weeks 1–3, plus accounts
                   week 5   what only a real phone can do
                   week 6   your own app, from an empty folder
```

Week 3 is the keystone. Weeks 1–2 exist so that week 3 makes sense, and week 3 exists
so that the template in week 4 contains nothing you haven't built yourself.

**Shelf** is the app you build in weeks 1–5: a reading tracker. Search for books,
put them on shelves (Want to read, Reading, Done), track your page, scan a barcode to
add one, and get reminded to read.

---

## Before day 1

Do [SETUP.md](SETUP.md). All of it, before the first live hour: `flutter doctor`
green, an Android emulator running, and the starter app on it. Setup problems are
the biggest risk in week 1, and they're cheaper to solve the week before.

---

## Daily rhythm

| | |
|---|---|
| **Live hour** | One hour with your instructor, five days a week |
| **Independent** | Four or more hours a day: the lesson, the exercises, the device checks |
| **Friday** | No new content. Defend, ship, retro. |

Every lesson has the same shape: **Read first** (official docs, timed), **What you need
to know**, **Exercises**, **Before tomorrow**. Every day ends with a row in
[logs/signal-log.md](logs/signal-log.md). Your instructor reads it before deciding
what tomorrow's live hour is for.

---

## The repository

```
README.md, SETUP.md, CUT_LIST.md, SOURCES.md
week-01/ … week-06/     one lesson per day, plus README and DEFEND (Friday) each week
week-04/tests/          tests you copy into shelf_v2 (also week-05/tests/)
shelf/                  weeks 1–3: the Flutter project you turn into Shelf
ai/                     the AI roles: tutor, editor, planner, defend
logs/                   signal log, stuck log, ship log
```

From week 4 you work in **`shelf_v2/`**, your own copy of the course's app template
(`mobile-app-template`, link from your instructor), next to `shelf/`. In week 6 your
capstone is a new repository of its own.

## Running the tests

Tests are the grader for behaviour. A green test means "this behaves correctly", not
"this is good code": the **editor** ([ai/editor.md](ai/editor.md)) judges that, and
your instructor judges both on Friday. Every test fails before you write anything.

```bash
# weeks 1–3
cd shelf
flutter test test/week_01/day_2_test.dart   # one day
flutter test test/week_02                   # one week
flutter test                                # everything so far

# weeks 4–5 (copy each day's tests in first; the lesson says which)
cd shelf_v2
flutter test test/week_04
bash tool/check.sh                          # formatting, lints and every test
```
