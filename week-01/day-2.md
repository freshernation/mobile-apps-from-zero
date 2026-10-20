# Day 2 — The `Book` model, and null safety

> **By the end of today** Shelf has a `Book` class that knows its authors, its
> progress, how to copy itself with one change, how to compare itself to another
> book, and how to turn itself into JSON and back.

Every app is built around a few **models**: plain classes that hold the app's data.
Shelf has one, `Book`. Everything you build in the next five weeks (screens, the
database, the search) passes `Book`s around. Write it carefully once, and every later
day gets easier.

Today's big idea is **null safety**. In many languages, any variable can secretly be
`null`, and you find out at runtime with a crash. In Dart a variable **cannot** be null
unless its type says so with a `?`. The compiler checks every use.

---

## Read first

- [ ] [Understanding null safety](https://dart.dev/null-safety/understanding-null-safety): up to and including *Working with nullable types* · 20 min
- [ ] [Classes](https://dart.dev/language/classes) and [Constructors](https://dart.dev/language/constructors): skim; read *Initializing formal parameters* and *Named parameters* properly · 15 min
- [ ] [Enums](https://dart.dev/language/enums): *Declaring enhanced enums* · 5 min

---

## What you need to know

### `int` vs `int?`

```dart
int pages = 412;
pages = null;            // compile error: an int is never null

int? pageCount = null;   // fine: int? means "an int, or nothing"
pageCount + 1;           // compile error: it might be null
```

Before you can use an `int?` as an `int`, you have to **prove** it isn't null. The
cleanest proof is to copy it into a local variable and check:

```dart
final pages = pageCount;
if (pages == null) return 0;
return currentPage / pages;      // here Dart knows pages is an int
```

Why copy to a local first? A field could change between the check and the use, so
Dart doesn't trust a check on a field. It does trust a check on a local `final`.

Three operators come up every day:

```dart
book.pageCount ?? 0            // ?? : "or this, if null"
counts[author] ?? 0            // (you used this yesterday)
book.coverUrl?.length          // ?. : "only if not null, else the whole thing is null"
json['title']!                 // !  : "I promise this isn't null" — crashes if you're wrong
```

Use `!` sparingly. Each one is a place your app can crash.

### Reading `Book`'s constructor

Open `shelf/lib/domain/models/book.dart`. The constructor is written for you:

```dart
const Book({
  required this.id,                     // must be given
  required this.title,
  this.authors = const [],              // optional, defaults to an empty list
  this.pageCount,                       // optional, defaults to null (it's int?)
  this.coverUrl,
  this.status = ShelfStatus.wantToRead,
  this.currentPage = 0,
});
```

Every line is a decision about the real world. Every book has an id and a title.
A book from a search might have no authors. Plenty of books have no known page count,
so `pageCount` is `int?` rather than defaulting to some fake number like `0`. A
fake `0` is a lie the rest of the app would have to remember to ignore.

`this.title` in a constructor means "assign this argument to the `title` field".
`const` lets you write `const Book(...)` when every value is known at compile time,
like the test's `dune` book.

### An enum with a label

```dart
enum ShelfStatus {
  wantToRead,
  reading,
  done;

  String get label => switch (this) {
        ShelfStatus.wantToRead => 'Want to read',
        // ...
      };
}
```

A `switch` **expression** returns a value. Leave out a case and Dart refuses to
compile, so when you add a fourth shelf later, the compiler lists every place you
forgot to handle it.

`ShelfStatus.reading.name` is the string `'reading'`. `ShelfStatus.values.byName('reading')`
goes the other way. You'll need both for JSON.

### Immutable, with `copyWith`

Every field is `final`, so a `Book` never changes after it's made. To "move a book to
Reading" you make a **new** `Book` that's the same except for one field:

```dart
final moved = dune.copyWith(status: ShelfStatus.reading);
```

This feels like extra work today. It pays off in week 3: when data only ever gets
replaced, never changed in place, "what changed?" has a simple answer, and Flutter
uses that answer to decide what to redraw.

Inside `copyWith`, `title ?? this.title` means "the new title if one was passed,
otherwise the current one".

### `==` and `hashCode`

```dart
final a = Book(id: '1', title: 'Dune');   // two separate objects
final b = Book(id: '1', title: 'Dune');
a == b;     // false — until you override ==
```

(Why not `const` here? Two identical `const` expressions are the *same* object, as
Dart makes only one, so they'd be equal even without an override. That's handy, and
also exactly why this example can't use `const`.)

By default `==` asks "are these the **same object**?", not "do they hold the same
values?". For a model you want the second meaning, so you override `==`:

```dart
@override
bool operator ==(Object other) =>
    other is Book && other.id == id && other.title == title /* && ...every field */;
```

And the rule: **if you override `==`, you must override `hashCode`** so that equal
objects have equal hash codes. Sets and maps use `hashCode` to find things. Break the
rule and a `Set<Book>` will happily hold two "equal" books.

```dart
@override
int get hashCode => Object.hash(id, title, /* ...every field */);
```

One trap: `['A'] == ['A']` is **false** in Dart, because lists compare by identity
too. For `authors`, compare the lists item by item, and hash them with
`Object.hashAll(authors)`.

### JSON

JSON is how data leaves your app (to a server, to a database). In Dart it's a
`Map<String, Object?>`:

```dart
{'id': '1', 'title': 'Dune', 'authors': ['Frank Herbert'], 'pageCount': 412, ...}
```

`toJson()` builds that map, and `Book.fromJson(map)` reads it back. Reading is where
null safety earns its keep. A value from JSON is an `Object?`, so you **cast** it to
what you expect:

```dart
title: json['title']! as String,               // required: must be there
pageCount: json['pageCount'] as int?,          // optional: may be missing
currentPage: (json['currentPage'] as int?) ?? 0,
```

`authors` is the fiddly one: `json['authors']` is a `List<dynamic>`, not a
`List<String>`. Look up `.cast<String>()`. And it can be **missing**: the test with
only `id` and `title` expects an empty list then, not a crash. One way to write
"the list, cast, or nothing":

```dart
authors: [...?(json['authors'] as List?)?.cast<String>()],
```

Read it inside out: `as List?` (a list or null), then `?.cast<String>()` (cast it,
unless it's null), then `...?` (spread its items into this new list, unless it's
null, in which case add nothing). The same goes for `status`: if it's missing, use
`ShelfStatus.wantToRead`.

---

## Exercises

Implement everything that throws in `book.dart`, in this order. Run the tests after
each:

```bash
cd shelf
flutter test test/week_01/day_2_test.dart
```

1. `label`: a switch expression.
2. `authorLine`: `join` is your friend.
3. `progress`: the three tests for unknown, zero and over-100% are the real exercise.
   Look up `clamp`.
4. `copyWith`.
5. `==` and `hashCode`: the test with `.toList()` is checking that you compare
   authors by value.
6. `toJson`, then `fromJson`. The round-trip test passes only once `==` works, which is
   why it's last.

---

## Before tomorrow

- [ ] All of today's tests, and yesterday's, green: `flutter test test/week_01`.
- [ ] Write one sentence in your own words in `logs/signal-log.md`: **why does `pageCount`
      have a `?` but `title` doesn't?** You'll be asked on Friday.
