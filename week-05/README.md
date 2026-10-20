# Week 5 — Real-device work

> **By Friday** Shelf scans books with the camera, reminds you to read, opens a book
> from a push notification, works for screen readers and large text, looks at home
> on iOS and Android, and installs as a signed release build. It's **Project 3**, and
> it's the app you'd show someone. You also have a plan for your own app.

This is the week the simulator stops being enough. The camera, notifications, screen
readers and release builds can only be proven on a real phone, so the ship log
matters more than ever.

| Day | | You build | Tests (each day, copy that day's file from `week-05/tests/` into `shelf_v2/test/week_05/`) |
|---|---|---|---|
| 1 | [The camera: scan a book to add it](day-1.md) | ISBN checking, lookup, the scan screen | `day_1_test.dart` |
| 2 | [Notifications: a nudge, and a push](day-2.md) | A reminder at your time, a push that opens a book | `day_2_test.dart` |
| 3 | [For everyone](day-3.md) | Every state, tooltips, screen-reader text, large text, adaptive dialogs | `day_3_test.dart` |
| 4 | [Ship it](day-4.md) | Icon, launch screen, signed release build, `CAPSTONE.md` | (ship log) |
| 5 | **Friday: Project 3** | [Defend](DEFEND.md), capstone sign-off, retro | |

```bash
cd shelf_v2
flutter test test/week_04 test/week_05     # every day copied in so far
bash tool/check.sh
```

## Project 3 — Shelf, release-ready

**Passed when:**
- `flutter test` (weeks 4 and 5 included) and `bash tool/check.sh` are green.
- Your ship log has, **from a real phone**:
  - a scan adding a book, and the permission-denied message;
  - the reminder arriving on a locked phone;
  - a push opening a book with the app closed;
  - TalkBack or VoiceOver reading the book screen;
  - the largest text size on every screen;
  - your icon, the launch screen, and the release build running.
- `CAPSTONE.md` is signed off by your instructor.
- You pass the [defense](DEFEND.md).
