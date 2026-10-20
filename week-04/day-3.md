# Day 3 — Books, in the cloud

> **By the end of today** Shelf v2 has its own data: a `Book` model, a
> `BookRepository` with a Firebase implementation and a test fake, and the same
> contract tests the template uses, passing against both.

The template's example record is an **item**. Today you give Shelf v2 its real one,
`Book`, by doing what the template's README calls "rename `items` to your domain",
which in practice means adding a domain alongside and removing the example tomorrow.
You've written everything here once already, in weeks 1 and 3. Today is about doing
it the template's way, and fast.

AI may help today. The rule stands: **nothing you can't explain gets committed.**

---

## Read first

- [ ] [Cloud Firestore data model](https://firebase.google.com/docs/firestore/data-model) · 10 min
- [ ] [Access data offline](https://firebase.google.com/docs/firestore/manage-data/enable-offline): the intro · 5 min
- [ ] Re-read the template's `test/contracts/item_repository_contract.dart`. Tomorrow's
      exercise depends on you understanding why it exists · 10 min

---

## What you need to know

### `Book`, plus one field

Start from your week 3 `book.dart` and add **`updatedAt`** (a `DateTime`, always
UTC), required in the constructor, in `copyWith`, `==`, `hashCode` and JSON. In JSON
it's an ISO-8601 string in UTC, exactly as `DateTime.toUtc().toIso8601String()` writes
it: `'2026-10-20T09:30:00.000Z'`. `fromJson` needs only `id`, `title` and
`updatedAt`; everything else falls back to the constructor's defaults.

Why `updatedAt`? With your shelf on two phones, "newest first" has to mean the same
thing on both. The server's order is the truth, and the timestamp is how you ask for
it.

`Book.fromOpenLibrary(doc, {DateTime? now})` sets `updatedAt` to `now` (or the
current time). Tests pass `now:` so they get a fixed time.

### `BookRepository`

`lib/data/repositories/books/book_repository.dart`, the same shape as
`ItemRepository`:

```dart
abstract class BookRepository {
  Future<Result<List<Book>>> getBooks();          // newest updatedAt first
  Future<Result<Book>> getBook(String id);
  Future<Result<Book>> addBook(Book book);        // keeps book.id; updatedAt = now
  Future<Result<Book>> updateBook(Book book);     // updatedAt = now; NotFound if missing
  Future<Result<void>> deleteBook(String id);
}
```

One difference from items: books **bring their own id** (Open Library's `OL…W`),
so `addBook` saves under `book.id` instead of the database inventing one. Adding the
same id twice replaces it. Tomorrow's search screen makes sure that only happens on
purpose.

### On Firebase

`book_repository_firebase.dart` keeps each user's books at
`users/{uid}/books/{bookId}`, the path yesterday's rules protect. Copy the shape of
`item_repository_firebase.dart`:

- `_guard` gets the signed-in user's collection (`NotSignedInException` if there
  isn't one) and maps Firebase errors to the app's.
- Writes are **started, not awaited** (`_write`). Firestore saves to the phone at once
  and syncs later, but its Future only completes when the *server* confirms. Await it
  and Save spins forever on a train. There's a test for this.
- `updatedAt` is stored as a Firestore `Timestamp` (so it sorts), and turned back into
  a `DateTime` on the way out.

### The fake, and the contract

`testing/fakes/fake_book_repository.dart`: an in-memory repository per user, with a
`failWith` exception you can set to make every call fail. It's the same as
`FakeItemRepository`, books instead of items. Tomorrow's view-model tests run on it.

`test/week_04/book_repository_contract.dart` (copied in with this week's tests) is
**one set of promises** both your fake and your Firebase repository must keep:
order, round-trips, `NotFound`, user isolation, signed-out. When the fake and the
real thing pass the same tests, a view-model test that passes on the fake means
something.

---

## Exercises

1. `lib/domain/models/book.dart`: `ShelfStatus` and `Book` with `updatedAt`.
2. `lib/data/repositories/books/book_repository.dart` and
   `book_repository_firebase.dart`.
3. `testing/fakes/fake_book_repository.dart`.
4. Don't delete `items` yet. The app still uses it until tomorrow.

```bash
flutter test test/week_04/day_3_test.dart
bash tool/check.sh
```

5. **Prove the rules match the code:** your repository writes to
   `users/{uid}/books/{id}`. Find the line in `firestore.rules` that allows exactly
   that, and nothing wider.

---

## Before tomorrow

- [ ] Day 1 and day 3 tests green; `check.sh` green.
- [ ] Signal log. In "hardest thing", explain why `_write` doesn't `await`.
