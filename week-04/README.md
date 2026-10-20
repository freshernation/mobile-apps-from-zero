# Week 4 — The template, and the cloud

> **By Friday** Shelf v2 runs on the course's app template: accounts on Firebase,
> your shelf synced between phones, working offline. You built it in four days,
> because everything in the template is something you built by hand in weeks 1–3.

This week you stop building the foundations and start standing on them. Starting
today:

> **AI may write code with you. You may not commit a line you could not have written
> and cannot explain on Friday.**

| Day | | You build | Tests (each day, copy that day's file from `week-04/tests/` into `shelf_v2/test/week_04/`) |
|---|---|---|---|
| 1 | [The template: nothing in it is new](day-1.md) | `shelf_v2/`, renamed, recoloured, running | `day_1_test.dart` |
| 2 | [Accounts in the cloud: Firebase](day-2.md) | A Firebase project, rules deployed, sign-in on two devices | (ship log) |
| 3 | [Books, in the cloud](day-3.md) | `Book`, `BookRepository` on Firebase, a fake, the contract | `book_repository_contract.dart` + `day_3_test.dart` |
| 4 | [Shelf's screens, the template's way](day-4.md) | Three view models, three screens, unused backends removed | `day_4_test.dart` |
| 5 | **Friday** | [Defend](DEFEND.md), ship, retro | |

```bash
cd shelf_v2
flutter test test/week_04          # the days you've copied in so far
bash tool/check.sh
```

## Passed when

- `flutter test test/week_04` and `bash tool/check.sh` are green.
- Your ship log shows: the renamed app, sign-in on two devices, the Rules Playground
  denying another user, and a book syncing between two phones (including a change
  made in airplane mode).
- `NOTES.md` has your week 3 → template map and the three-backend reading answers.
- You pass the [defense](DEFEND.md).
