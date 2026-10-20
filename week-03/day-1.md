# Day 1 — A place for the data: `Result`, `Command`, and a repository

> **By the end of today** Shelf has a **data layer**: one interface that says what you
> can do with books, an in-memory version of it, and two small tools, `Result` and
> `Command`, that every screen will use to say "loading", "failed" or "done".

Last Thursday you felt it: the books lived in `ShelfApp`, every change had to go
through `_change`, and forgetting a line meant a screen showing old data. This week
fixes that in two moves:

1. **Today:** give the data its own home, a **repository**, so the question "where
   do books come from?" has one answer in one place.
2. **Tomorrow:** give the logic its own home, a **view model**, so screens just show
   things and forward taps.

There's no UI today. It's all pure Dart and tests, which makes it the most important
code you'll write this course. Week 4's template is built from exactly these pieces.

---

## Read first

- [ ] [Guide to app architecture: Concepts](https://docs.flutter.dev/app-architecture/concepts) · 15 min
- [ ] [Data layer](https://docs.flutter.dev/app-architecture/case-study/data-layer): the *Repositories* part · 10 min
- [ ] [Result objects](https://docs.flutter.dev/app-architecture/design-patterns/result) · 10 min
- [ ] [The command pattern](https://docs.flutter.dev/app-architecture/design-patterns/command) · 15 min

---

## What you need to know

### A repository is the one door to the data

```dart
abstract class BookRepository {
  Future<Result<List<Book>>> getBooks();
  Future<Result<Book>> addBook(Book book);
  Future<Result<Book>> updateBook(Book book);
  Future<Result<void>> deleteBook(String id);
}
```

`abstract` means it's only a promise. It has no code, just the four things you can
ask for. Today's `InMemoryBookRepository` keeps the books in a list. On Thursday,
`SqliteBookRepository` keeps them on the phone, and in week 4 there's one that keeps
them on a server. **The rest of the app will never know which one it's talking to.**
That's the whole point: you can swap where data lives without touching a single
screen.

Every method is `async`, even in memory where nothing is slow, because the real ones
will be. Make the interface honest about that now.

### `Result`: failure you can't ignore

`lib/utils/result.dart` is already written. Read it. It's twenty lines:

```dart
sealed class Result<T> { ... }
final class Ok<T> extends Result<T> { final T value; }
final class Error<T> extends Result<T> { final Exception error; }
```

Instead of throwing, a repository **returns** either `Ok(value)` or `Error(exception)`.
Because the class is `sealed`, a `switch` on it must handle both, or it won't compile:

```dart
switch (await repository.updateBook(book)) {
  case Ok(:final value):
    // use value
  case Error(:final error):
    // you're forced to decide what failure means here
}
```

Compare last week's `try`/`on`: forgetting the `catch` compiles fine and crashes in
your user's hand. Forgetting the `Error` case here doesn't compile. Same idea, and
the compiler checks it.

### Hand out copies

```dart
Future<Result<List<Book>>> getBooks() async => Result.ok([..._books]);
```

If `getBooks` returned `_books` itself, whoever called it could `.clear()` your data
from outside. `[..._books]` is a new list with the same books in it. The books are
immutable already (week 1 paid off), so a copy of the list is enough. Copy what
you're **given** in the constructor too, for the same reason in the other direction.

### `Command`: an action, plus whether it's running

Every button that does something slow needs the same four things: run the action,
know it's running (show a spinner, disable the button), know it failed (show why), and
know it worked. Without a pattern, every screen invents its own `_isLoading`,
`_error` and `_done` booleans, and gets one of them wrong.

```dart
final save = Command1<void, Book>(repository.addBook);

save.running      // true while the Future is in flight
save.error        // the last run was an Error
save.completed    // the last run was Ok
save.result       // the Result itself
await save.execute(book);
```

`Command` is a `ChangeNotifier`: it calls `notifyListeners()` when it starts and when
it finishes, so a screen can redraw. You've used `setState` to redraw yourself. A
`ChangeNotifier` is how *something else* tells listeners "I changed, redraw".

One subtle rule: if it's already running, a second `execute` must **not** run the
action again. That's what stops a double-tap from adding a book twice. Return the run
that's already in flight instead, so whoever awaits the second call still waits for
the real finish. Hint: keep the in-flight `Future` in a field, `??=` is your friend,
and clear it when the run finishes.

---

## Exercises

1. Read `result.dart` and `book_repository.dart`. Nothing to write. Make sure you could
   explain every line.
2. Write `InMemoryBookRepository` in `lib/data/repositories/book_repository_memory.dart`.
   Watch the two "copy" tests.
3. Write `Command`, `Command0` and `Command1` in `lib/utils/command.dart`. Do the first
   two tests, then the double-run ones, then notifications.

```bash
cd shelf
flutter test test/week_03/day_1_test.dart
```

Nothing on screen changes today. That's fine. Tomorrow plugs this in, and it's why
the plug-in is easy.

---

## Before tomorrow

- [ ] Day 1 green, and weeks 1–2 still green.
- [ ] Signal log. In "hardest thing", explain in your own words why `execute` returns
      the in-flight run instead of just returning early.
