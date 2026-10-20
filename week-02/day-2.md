# Day 2 — Lists

> **By the end of today** Shelf has a home screen that lists your books shelf by shelf,
> scrolls smoothly through two hundred of them, and tells you when a shelf is empty.

Almost every app is a list of things you tap to see more: messages, products, songs,
books. Get lists right and you've built half of most apps.

---

## Read first

- [ ] [Work with long lists](https://docs.flutter.dev/cookbook/lists/long-lists) · 10 min
- [ ] [`ListTile`](https://api.flutter.dev/flutter/material/ListTile-class.html): the intro and the first example · 10 min
- [ ] [`Expanded`](https://api.flutter.dev/flutter/widgets/Expanded-class.html) · 5 min

---

## What you need to know

### `ListView.builder` builds only what's on screen

```dart
ListView.builder(
  itemCount: books.length,
  itemBuilder: (context, index) => ListTile(title: Text(books[index].title)),
)
```

Yesterday's `ListView(children: [...])` builds every child up front. That's fine for
a screen with ten widgets, and terrible for a list of thousands. `ListView.builder`
calls `itemBuilder` only for the rows you can see (plus a few either side), and
builds more as you scroll. One of today's tests checks that row 199 isn't built until
you scroll to it.

### `ListTile`, the row you'll use everywhere

```dart
ListTile(
  key: Key('book-${book.id}'),
  leading: const Icon(Icons.menu_book),
  title: Text(book.title),
  subtitle: Text(book.authorLine),
  onTap: onTap,
)
```

It gives you Material spacing, an ink ripple on tap, and accessibility for free.
`subtitle` can be any widget, so for a book being read, make it a `Column` with the
authors and a `LinearProgressIndicator(value: book.progress)`.

The key uses the book's **id**, not its position. Keys say "this row is *this
book*", which is what lets tests (and Flutter) follow a row when the list changes.

### Filtering is just Dart

```dart
final books = widget.books.where((b) => b.status == _shelf).toList();
```

You wrote this on day 1 of week 1. The filtered list is computed in `build`, from
two things: the books you were given, and the shelf you picked. Don't store the
filtered list in state. Store the **choice** (`_shelf`) and derive the rest. Stored
copies go stale, and derived values can't.

Which shelf is picked is local, temporary UI state, so `ShelfScreen` is a
`StatefulWidget` and owns `_shelf` with `setState`, like yesterday's slider. The
books themselves aren't its to own. They come in through the constructor.

### A list inside a column needs `Expanded`

```dart
Column(
  children: [
    SegmentedButton(...),          // as tall as it needs
    Expanded(child: ListView...),  // all the rest of the height
  ],
)
```

A `ListView` wants infinite height, and a `Column` offers its children infinite
height. Put one in the other without `Expanded` and you get *"Vertical viewport was
given unbounded height"*, the most-searched Flutter error there is. `Expanded` says
"you get exactly the leftover space".

### Empty states aren't optional

A blank screen looks broken. Every list needs an answer to "what if there's
nothing?":

```dart
books.isEmpty
    ? const Center(key: Key('empty-shelf'), child: Text('Nothing on this shelf yet.'))
    : ListView.builder(...)
```

### A floating button, if anyone's listening

```dart
floatingActionButton: switch (widget.onAdd) {
  final onAdd? => FloatingActionButton(onPressed: onAdd, child: const Icon(Icons.add)),
  null => null,
},
```

Same idea as yesterday's delete button: no callback means no button.

---

## Exercises

1. Write `ShelfScreen` in `shelf/lib/ui/shelf/shelf_screen.dart`. The doc comment lists
   every key and text the tests look for. Split the row into its own small `_BookRow`
   widget.

```bash
cd shelf
flutter test test/week_02/day_2_test.dart
```

2. On a device, change `main.dart` to show
   `ShelfScreen(books: sampleBooks, onBookTap: print)`. Then make 200 books
   (`List.generate`) and fling the list. It should never stutter.
3. **Get the error on purpose:** remove `Expanded` around the list and run. Read the
   whole error message: it explains the fix. Put `Expanded` back.

---

## Before tomorrow

- [ ] Tests green, including weeks 1 and 2-day-1.
- [ ] **Ship log:** a screenshot of a shelf with books, and one of an empty shelf.
- [ ] Signal log.
