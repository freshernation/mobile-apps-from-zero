# Day 4 — Your first screen: everything is a widget

> **By the end of today** Shelf opens on a screen you built: a book's cover, title,
> authors, page count and shelf, laid out properly and running on your device.

Three days of Dart were for this. A Flutter screen is just Dart: a class with a
`build` method that returns a description of what to draw. Flutter calls `build`,
draws the result, and calls it again whenever something changes.

The description is a **tree of widgets**. A `Column` holds a `Text` and a `Row`, the
`Row` holds a `Chip` and another `Text`, and so on down. Learning Flutter is mostly
learning about thirty widgets and how they nest. Today you meet the first ten.

---

## Read first

- [ ] [Building user interfaces with Flutter](https://docs.flutter.dev/ui): the whole page · 20 min
- [ ] [Layouts in Flutter](https://docs.flutter.dev/ui/layout): up to and including *Lay out multiple widgets vertically and horizontally* · 25 min
- [ ] Bookmark the [Widget catalog](https://docs.flutter.dev/ui/widgets). You'll look things up there daily.

---

## What you need to know

### A `StatelessWidget`

```dart
class BookDetailScreen extends StatelessWidget {
  const BookDetailScreen({super.key, required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    return Text(book.title);
  }
}
```

"Stateless" means the widget holds nothing that changes: give it the same `book` and
it always draws the same thing. That covers most widgets you'll write. Next week
you'll meet the stateful kind.

`super.key` passes an optional `Key` up to Flutter. Keys are how tests find a
specific widget, and you'll put one on every piece today.

### The skeleton of a screen

```dart
return Scaffold(
  appBar: AppBar(title: Text(book.title)),
  body: ListView(
    padding: const EdgeInsets.all(24),
    children: [
      // ...your widgets, top to bottom
    ],
  ),
);
```

| Widget | Job |
|---|---|
| `MaterialApp` | The root: theme, navigation, text direction. One per app. |
| `Scaffold` | One screen: app bar, body, the floating button later. |
| `AppBar` | The bar at the top. |
| `ListView` | A scrollable column. Use it for the body of any screen that might be taller than the phone. |

A plain `Column` doesn't scroll. Put too much in it on a small phone and you get the
yellow-and-black overflow stripes. A `ListView` with `children:` is the easy fix.

### Laying things out

```dart
Row(
  children: [
    Chip(label: Text(book.status.label)),
    const SizedBox(width: 12),             // a gap
    Expanded(child: Text('412 pages')),    // take the rest of the width
  ],
)
```

- `Column` stacks top to bottom, and `Row` left to right.
- `SizedBox(height: 16)` is the simplest spacer. Spacing between things belongs to the
  parent layout, not to padding on every child.
- `Padding(padding: EdgeInsets.all(8), child: …)` adds space around one widget.
- `Expanded` says "this child takes the leftover space". Without it, a long `Text` in a
  `Row` overflows off the screen.
- `Center` centres its child.

### Text that uses the theme

```dart
final textTheme = Theme.of(context).textTheme;

Text(book.title, style: textTheme.headlineSmall)
Text(book.authorLine, style: textTheme.titleMedium)
```

Don't pick font sizes by hand. The theme has a named scale (`headlineSmall`,
`titleMedium`, `bodyLarge`…). Use it and the app stays consistent, and it respects
the user's text-size setting, which is an accessibility basic.

`Theme.of(context)` is your first sight of `BuildContext`: it's how a widget asks
"what's above me in the tree?". Here it asks "which theme am I in?".

### Images from the internet, and when they fail

```dart
Image.network(
  url,
  width: 120,
  height: 180,
  fit: BoxFit.cover,
  errorBuilder: (context, error, stackTrace) => const Icon(Icons.menu_book),
)
```

Network images fail all the time: no signal, a dead link. Without `errorBuilder` a
failed image is drawn as an error, and in a test it's a crash. With it, you choose
what shows instead. Always give network images a fallback.

`coverUrl` is a `String?`. You need the null-check pattern from day 2 here:
copy it to a local, and `if (coverUrl == null) return placeholder;`.

### A private helper widget

When `build` gets long, split a piece out into its own small widget in the same file.
Start its name with `_` so it's private to the file:

```dart
class _Cover extends StatelessWidget {
  const _Cover({required this.url});
  final String? url;
  // ...
}
```

Prefer a small widget class over a helper *method* that returns a widget. Flutter can
skip rebuilding a widget whose inputs didn't change. It can't do that for a method.

---

## Exercises

1. Build `BookDetailScreen` in `shelf/lib/ui/book_detail/book_detail_screen.dart`. The
   tests find every piece by its `Key`, and the comment at the top of the file lists
   them. Run:
   ```bash
   cd shelf
   flutter test test/week_01/day_4_test.dart
   ```
2. Replace the counter app. Make `shelf/lib/main.dart` show your screen:
   ```dart
   void main() {
     runApp(MaterialApp(home: BookDetailScreen(book: sampleBooks.first)));
   }
   ```
   Delete everything else in the file.
3. `flutter run`. While it runs, change `sampleBooks.first` to `sampleBooks[2]` (no
   page count, two authors) and hot reload. Then add a `coverUrl` to a sample book, for
   example `'https://covers.openlibrary.org/b/id/12699637-M.jpg'`, and reload again.
4. **Make it yours.** Spacing, which text gets which style, where the chip goes: the
   tests check *what* is shown, not how it looks. On Friday you'll explain one layout
   choice you made.

---

## Before tomorrow

- [ ] `flutter test test/week_01`: all four days green.
- [ ] **Ship log:** a screenshot of your detail screen on a device, one with a cover
      and one without. On a Mac, take one on iOS as well. Notice what looks different
      between the platforms even though the code is the same.
- [ ] Signal log row.
- [ ] Read `week-01/DEFEND.md`. Tomorrow is Friday.
