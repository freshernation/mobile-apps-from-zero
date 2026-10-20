# Day 4 — Shelf's screens, the template's way

> **By the end of today** Shelf v2 is Shelf again: your shelf, search, a book's page
> with its progress, delete. Now it has accounts, syncs between your phones, and works
> offline. The template's example items are gone.

You've built each of these screens before. The difference is the wiring:
**one view model per screen**, created with the router's `_page(...)`, holding
Commands; screens that show and ask; errors that always reach the user.

---

## Read first

- [ ] The template's `lib/ui/items/` folder, every file, as the pattern you're
      following · 20 min
- [ ] The template's `lib/routing/router.dart`, the `_page` helper and its comment ·
      5 min

---

## What you need to know

### Three view models

| View model | Owns | Commands |
|---|---|---|
| `ui/books/shelf_view_model.dart` — `ShelfViewModel({books, auth, notifications})` | `books` (newest first), `booksWith(status)` | `load` (runs at once), `setStatus((id:, status:))`, `setPage((id:, page:))`, `delete(id)`, `signOut`, `setReminder(TimeOfDay)` (you'll wire it in week 5) |
| `ui/books/book_view_model.dart` — `BookViewModel({books, bookId})` | `book` | `load`, `setStatus(status)`, `setPage(page)`, `delete` |
| `ui/search/search_view_model.dart` — `SearchViewModel({service, books})` | `results`, `isOnShelf(id)` (knows the books already on your shelf when it opens) | `search(query)`, `addToShelf(book)` (on Want to read; a book already on the shelf is left alone) |

The rules you wrote in week 3 come back. Moving to **Done** puts you on the last
page, and a page is clamped between 0 and the page count. Write them once, as
plain functions, and use them from both `ShelfViewModel` and `BookViewModel`:

```dart
Book applyStatus(Book book, ShelfStatus status) => ...;
Book applyPage(Book book, int page) => ...;
```

A changed book moves to the top of the shelf, because its `updatedAt` is now the newest.

### Three screens, and their keys

The tests find things by these keys. Put each one on the widget itself.

| Screen | Keys |
|---|---|
| `ShelfScreen` (`/`) | `status-filter` (the `SegmentedButton`), `book-$id` (each row), `empty-shelf`, `add-book` (the button that opens search), `menu` with `remind-me` and `sign-out` |
| `SearchScreen` (`/search`) | `search-field`, `result-$id`, `add-$id` (an add icon that becomes a check), `search-empty`, `search-error` with `retry` |
| `BookDetailScreen` (`/books/:id`) | `book-title`, `status-picker`, `progress-slider` and `progress-label` (while reading), `delete-book`, then a confirm dialog with `confirm-delete` |

The routes live in `Routes`: `Routes.home`, `Routes.search`, `Routes.book(id)`. The
notification allowlist in `routing/notification_router.dart` changes from
`/items/…` to `/books/…`, so a push can open a book.

### Pull to refresh works on an empty shelf too

New books land on Want to read, but the shelf opens on Reading, so a fresh phone
often shows an empty shelf. It must still be pullable, or a book added on your other
phone never appears. Put the empty message *inside* the `RefreshIndicator`, in a list
that can always scroll:

```dart
RefreshIndicator(
  onRefresh: viewModel.load.execute,
  child: books.isEmpty
      ? ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [SizedBox(height: 120), Center(key: Key('empty-shelf'), child: Text(AppStrings.emptyShelf))],
        )
      : ListView.builder(...),
)
```

### Delete asks first

Deleting from every device at once deserves a second chance:

```dart
final confirmed = await showDialog<bool>(
  context: context,
  builder: (context) => AlertDialog(
    title: const Text(AppStrings.deleteConfirmTitle),
    actions: [
      TextButton(onPressed: () => Navigator.pop(context, false), child: const Text(AppStrings.cancel)),
      TextButton(key: const Key('confirm-delete'), onPressed: () => Navigator.pop(context, true), child: const Text(AppStrings.delete)),
    ],
  ),
);
if (confirmed ?? false) viewModel.delete.execute();
```

### Bring your own code

Search is yours from week 3. Copy `lib/data/services/open_library_service.dart` from
`shelf/` into `shelf_v2` (it now needs `Book.fromOpenLibrary(doc)` with `updatedAt`),
and rebuild the search screen on the template's pattern in `lib/ui/search/`.

And one string changes: the template's `AppStrings.notFound` talks about items. Make
it `Book not found.` A push for a deleted book (week 5) shows exactly that, and a test
checks it.

### Wiring

- `config/dependencies_firebase.dart` provides a `BookRepository`
  (`BookRepositoryFirebase`) and an `OpenLibraryService`, instead of the item
  repository.
- Every screen's view model is made in the router with `_page(...)`, never directly
  in a builder.
- Text the user sees goes in `AppStrings`.

### Remove what Shelf doesn't use

Shelf v2 runs on Firebase. Before deleting the others, do the reading exercise
below. Then delete: `lib/ui/items/`, the item model and repositories, `main_rest.dart`,
`main_supabase.dart`, their `dependencies_*` and config files, `api_client.dart`,
`local_db.dart`, `tool/dev_server.dart`, `supabase/`, and the tests that only test
those.

**Keep** the tests that check accounts and routing, because they still matter:
`test/routing/router_test.dart` (change its `ItemRepository` provider to your
`BookRepository` plus an `OpenLibraryService`, and drop the `/items/new` test),
the auth contract (`test/contracts/auth_repository_contract.dart`, with a
`fakes_contract_test.dart` that runs it on `FakeAuthRepository` and a Firebase one),
and `test/contracts/contract_helpers.dart`. Without the router tests, nothing checks
that signing out sends you back to sign-in. Then remove `supabase_flutter`, `sqflite`, `sqflite_common_ffi`, `shelf` and
`shelf_router` from `pubspec.yaml`. `check.sh` must end green.

Deleting code you don't use isn't a loss. It's the cheapest way to make the rest
easier to read.

---

## Exercises

1. **Read before you delete.** Put `item_repository_firebase.dart`,
   `item_repository_rest.dart` and `item_repository_supabase.dart` side by side, and
   answer in your `NOTES.md`:
   - Which one works offline, and how does each get there?
   - Where does each one stop user B from reading user A's items: in the app, or on
     the server?
   - If you had to move Shelf to Supabase next month, which files would change?
2. The three view models.
3. The three screens and the routes.
4. Wiring, then remove what you don't use.

```bash
cp ../week-04/tests/day_4_test.dart test/week_04/
flutter test test/week_04
bash tool/check.sh
```

5. **On two devices:** add a book on one, and it appears on the other after a pull to
   refresh. Turn on airplane mode, finish a book, and turn it off: the change syncs.

---

## Before tomorrow

- [ ] All of `test/week_04` green; `check.sh` green.
- [ ] **Ship log:** a recording of the two-device sync, and the airplane-mode change
      syncing afterwards.
- [ ] Read `week-04/DEFEND.md`.
