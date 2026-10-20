# Week 3 — Architecture, by hand

> **By Friday** Shelf is built in layers: screens that only show and ask, a view model
> that holds the rules, and repositories that hide where books live. It searches a
> real API, and it remembers your books after a restart. Every week 2 test still
> passes, because you changed how it's built, not what it does.

This is the keystone week. Last week you felt state spread through callbacks. This
week you give data, logic and screens each a home. On Monday of week 4 you'll be
handed a template, and the point of this week is that **nothing in it will be new**.

| Day | | You build | Tests |
|---|---|---|---|
| 1 | [A place for the data](day-1.md) | `Command`, `BookRepository` in memory | `test/week_03/day_1_test.dart` |
| 2 | [A place for the logic](day-2.md) | `ShelfViewModel`, and `ShelfApp` rebuilt on it | `day_2_test.dart`, plus all of week 2 |
| 3 | [A real server](day-3.md) | Open Library search | `day_3_test.dart` |
| 4 | [Remember](day-4.md) | SQLite: books survive a restart | `day_4_test.dart` |
| 5 | **Friday: Project 2** | [Defend](DEFEND.md), ship, retro | `project_2_test.dart` |

```bash
cd shelf
flutter test          # every week. All of it, every day.
```

## Project 2 — Shelf in layers

**Passed when:**
- `flutter test` is all green: weeks 1, 2 and 3, including `project_2_test.dart` (a book
  found on Open Library is still on the shelf after a restart).
- `flutter analyze` reports no issues.
- Your ship log has recordings of a real search, the airplane-mode error, and a book
  surviving a restart, on a device.
- You pass the [defense](DEFEND.md).

## You just built the template

Next week starts from the course's standard app template. Here's where everything you
wrote this week lives in it:

| You wrote (Shelf) | In the template | What's different there |
|---|---|---|
| `utils/result.dart` | `lib/utils/result.dart` | Nothing. |
| `utils/command.dart` | `lib/utils/command.dart` | Nothing. |
| `utils/app_exceptions.dart` | `lib/utils/app_exceptions.dart` | More kinds: sign-in failed, not signed in, invalid input, session expired. |
| `domain/models/book.dart` | `lib/domain/models/item.dart` | The example record. You'll rename it to your app's thing. |
| `data/repositories/book_repository.dart` | `lib/data/repositories/items/item_repository.dart` | Same idea, plus an `AuthRepository` for accounts. |
| `book_repository_memory.dart` | `testing/fakes/fake_item_repository.dart` | Used by tests, not the app. |
| `book_repository_sqlite.dart` + `local_db.dart` | `item_repository_rest.dart` + `lib/data/services/local_db.dart` | SQLite becomes a cache in front of a server. |
| — | `item_repository_firebase.dart`, `item_repository_supabase.dart` | **New:** the same interface on two cloud backends. |
| `data/services/open_library_service.dart` | `lib/data/services/api_client.dart` | A general client for your own server. |
| `ui/shelf/shelf_view_model.dart` | `lib/ui/items/items_view_model.dart`, `item_view_model.dart` | One view model per screen, not one shared one. |
| The `/search` route's `ChangeNotifierProvider(create:)` | `_page(...)` in `lib/routing/router.dart` | Every screen's view model is made that way. |
| `ui/core/theme.dart`, `routing/routes.dart` | Same paths | Nothing new. |
| `app.dart` | `lib/app.dart` + `lib/routing/router.dart` + `lib/config/` | Split into three. A redirect sends signed-out users to sign-in. |
| `main.dart` | `main.dart`, `main_supabase.dart`, `main_rest.dart` | One entry point per backend. |
| — | `lib/ui/auth/`, `notification_service.dart` | **New in week 4–5:** accounts and notifications. |

Read the right-hand column on Friday afternoon. Everything in it you either wrote or
can now read.

## The rules this week

The last week of **you write every line**. From Monday the rule becomes "you may not
commit a line you could not have written and cannot explain on Friday". This week is
what makes that possible.
