# Day 3 — Waiting: `Future`, `async`, `await`, and things that fail

> **By the end of today** you can call something slow, wait for its answer without
> freezing the app, and handle the answer not coming back the way you hoped.

Almost everything interesting an app does is slow: fetching from a server, reading
the database, asking for camera permission. If your code just sat and waited, the
screen would freeze: no scrolling, no animations, the system offering to kill your
app. Dart's answer is the `Future`: a value that **isn't here yet**.

Today there's no server. `SampleBookSource` pretends to be one: it waits 300 ms
and then answers. In week 3 you'll swap it for the real Open Library API, and the
`async` code you write today won't change shape at all.

---

## Read first

- [ ] [Asynchronous programming: futures, async, await](https://dart.dev/libraries/async/async-await): the whole page · 25 min
- [ ] [Error handling](https://dart.dev/language/error-handling): *Throw* and *Catch* · 10 min
- [ ] [Asynchronous programming: Streams](https://dart.dev/libraries/async/using-streams): to *Receiving stream events* · 10 min

---

## What you need to know

### A `Future` is a promise of a value

```dart
Future<List<Book>> results = source.search('dune');   // returns at once
// results is NOT a list yet — it's a box that will hold one
```

`await` waits for the box to fill, **without blocking anything else**:

```dart
Future<void> show() async {
  final results = await source.search('dune');   // List<Book>
  print(results.first.title);
}
```

Two rules:
1. You can only `await` inside a function marked `async`.
2. An `async` function always returns a `Future`. If it returns a `String`, its type is
   `Future<String>`.

So async spreads: if you call something async and need its answer, you become async
too. That's normal. Flutter is built for it.

### Writing a slow function

```dart
Future<List<Book>> search(String query) async {
  await Future<void>.delayed(delay);    // pretend to be a slow network
  // ... then work out the answer and return it
}
```

`Future.delayed` is "a Future that completes after this long". Tests create the
source with `delay: Duration.zero` so they don't wait.

### Failing, and catching

Some things don't just take time, they fail. `byId` can't return a book that
doesn't exist, so it **throws**:

```dart
throw BookNotFoundException(id);
```

The caller catches it with `try` / `on`:

```dart
try {
  final book = await source.byId(id);
  return book.title;
} on BookNotFoundException {
  return 'No book with id $id';
}
```

The `await` has to be **inside** the `try`. An error from a Future comes out at the
`await`, so if the await is outside the `try`, nothing catches it.

`on BookNotFoundException` catches only that type. A plain `catch (e)` catches
everything, which also hides bugs you didn't expect, like a typo that throws
`NoSuchMethodError`. Catch what you know how to handle and let the rest crash loudly
in development.

In week 3 you'll meet a different style: instead of throwing, a function returns a
`Result` that is either `Ok(value)` or `Error(exception)`, and the compiler makes the
caller deal with both. Today's `try`/`on` is what that pattern is built from.

### Matching text, ignoring case

```dart
final q = query.trim().toLowerCase();
book.title.toLowerCase().contains(q);
book.authors.any((author) => author.toLowerCase().contains(q));
```

`any` is `where`'s cousin: "is this true for **at least one** item?".

### A `Stream` is many values over time

A `Future` gives you one value later. A `Stream` gives you many: download progress,
a chat's new messages, a countdown.

```dart
Stream<int> ticks() async* {     // async*  (with a star) makes a Stream
  yield 1;                       // yield sends one value
  await Future<void>.delayed(const Duration(seconds: 1));
  yield 2;
}                                // the stream closes when the function ends

await for (final n in ticks()) {
  print(n);
}
```

You won't write many streams yourself. You'll mostly *listen* to ones Flutter and
Firebase give you, but you need to recognise the shape.

---

## Exercises

1. In `shelf/lib/data/sample_books.dart`, read `sampleBooks`. That's your data for the
   next two weeks. Then write `SampleBookSource.search` and `.byId`.
2. In `shelf/lib/exercises/day_3.dart`, write `firstTitleOrMessage`, `titleOrError`
   (with `try`/`on`, not by checking first) and `countdown`.

```bash
cd shelf
flutter test test/week_01/day_3_test.dart
```

The `countdown` test with `from: 0` expects **nothing** emitted. Make sure your loop
handles it.

**Try breaking it on purpose:** move the `await` in `titleOrError` outside the `try`
and run the tests. Read the failure, then put it back. Knowing what that failure looks
like will save you an hour in week 3.

---

## Before tomorrow

- [ ] `flutter test test/week_01`: days 1–3 green.
- [ ] Signal log row. In "hardest thing", explain in one line what `await` actually
      waits for.
