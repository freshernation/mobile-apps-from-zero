# Week 2 — Interactive, and more than one screen

> **By Friday** Shelf works: a shelf of books you can filter, open, move between
> shelves, track your page in, add to and delete from. Everything lives in memory,
> and closing the app forgets it (week 3 fixes that).

Last week's screen showed one book. This week's app is something you'd actually
use. Along the way you meet the question that shapes every app you'll ever build:
**where does the data live, and how do screens find out it changed?** This week's
answer works, and by Thursday you'll see why it doesn't scale. Feeling that is the
point. Week 3's answer only makes sense once you've felt it.

| Day | | You build | Tests |
|---|---|---|---|
| 1 | [State: widgets that change](day-1.md) | The progress slider, shelf picker and delete button | `test/week_02/day_1_test.dart` |
| 2 | [Lists](day-2.md) | `ShelfScreen`, a filterable list of books | `day_2_test.dart` |
| 3 | [Forms](day-3.md) | `AddBookScreen`, with validation | `day_3_test.dart` |
| 4 | [Screens that connect](day-4.md) | `ShelfApp`: routes, theme, the one list of books | `day_4_test.dart` |
| 5 | **Friday: Project 1** | [Defend](DEFEND.md), ship, retro | `project_1_test.dart` |

```bash
cd shelf
flutter test test/week_01 test/week_02     # everything so far
```

## Project 1 — Shelf, in memory

**Passed when:**
- `flutter test test/week_01 test/week_02` is all green, including `project_1_test.dart`
  (one book's whole life: added, read, finished, deleted).
- `flutter analyze` reports no issues.
- Your ship log has a screen recording of that same flow on a device, in light and
  dark mode.
- You pass the [defense](DEFEND.md).

## The rules this week

The same as last week: **you write every line**. Twenty minutes, then `ai/tutor.md`,
then the live hour. Device runs go in the ship log.
