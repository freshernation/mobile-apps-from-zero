# Week 1 — Dart, and your first screen

> **By Friday** you have a working toolchain, you can read and write everyday Dart
> (types, null safety, classes, async code), and Shelf opens on a book screen you
> built, running on your device.

You've written some code before. This week turns "some code" into **Dart**, and
"never built an app" into **an app on your phone**. It's deliberately small: one model
and one screen. Every later week stands on `Book` and on the way you learned to read
a test this week.

| Day | | You build | Tests |
|---|---|---|---|
| 1 | [Your toolchain, and enough Dart to start](day-1.md) | Six small functions, plus the counter app running with hot reload | `test/week_01/day_1_test.dart` |
| 2 | [The `Book` model, and null safety](day-2.md) | `Book`: progress, `copyWith`, equality, JSON | `day_2_test.dart` |
| 3 | [`Future`, `async`, `await`, and things that fail](day-3.md) | `SampleBookSource`, a pretend slow server | `day_3_test.dart` |
| 4 | [Your first screen](day-4.md) | `BookDetailScreen`, running on a device | `day_4_test.dart` |
| 5 | **Friday** | Nothing new: [defend](DEFEND.md), ship, retro | |

```bash
cd shelf
flutter test test/week_01          # the whole week
```

## The rules this week

- **You write every line.** AI is a tutor (`ai/tutor.md`), not an author, for weeks
  1–3.
- **Twenty minutes**, then the tutor, then the live hour. Log it in
  `logs/stuck-log.md`.
- **Nothing counts until the tests pass, it ran on a device, and it's pushed.** Device
  runs go in `logs/ship-log.md` with a screenshot.

## Friday

No new content. Three things:

1. **Defend.** Twenty minutes with your instructor, on your own code. The questions are
   in [DEFEND.md](DEFEND.md), so read them before Friday, not on it.
2. **Ship.** `flutter test test/week_01` is green, your ship log has the counter app
   and your detail screen on a device, and it's pushed.
3. **Retro.** In your signal log: what took longest this week, and what you'd do
   differently.
