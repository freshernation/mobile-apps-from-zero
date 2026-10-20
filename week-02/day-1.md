# Day 1 — State: widgets that change

> **By the end of today** the detail screen has a progress slider that follows your
> finger, a shelf picker, and a delete button. You'll know which of those hold
> **state** and which only **report** what happened.

Last week every widget was stateless: same input, same picture. Real screens
change while you look at them: a slider moves, a checkbox ticks, a list grows. The
data that changes is **state**, and today's question, which comes back every day
until week 3, is **who owns it?**

---

## Read first

- [ ] [Adding interactivity to your Flutter app](https://docs.flutter.dev/ui/interactivity): the whole page · 30 min. Its three approaches to "who manages the state" are exactly today's lesson.
- [ ] [`StatefulWidget`](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html): the intro and *Performance considerations* · 10 min

---

## What you need to know

### `StatefulWidget` is two classes

```dart
class ReadingProgress extends StatefulWidget {
  const ReadingProgress({super.key, required this.book, required this.onPageChanged});
  final Book book;
  final ValueChanged<int> onPageChanged;

  @override
  State<ReadingProgress> createState() => _ReadingProgressState();
}

class _ReadingProgressState extends State<ReadingProgress> {
  late int _page = widget.book.currentPage;      // the state (see below)

  @override
  Widget build(BuildContext context) {
    return Text('Page $_page');                  // ...used in build
  }
}
```

The **widget** is a cheap, immutable description that gets thrown away and rebuilt
constantly. The **State** object survives those rebuilds: it's where `_page` lives.
Inside the State, `widget.book` reads the widget's current fields.

`late` lets a field's starting value read `widget`, which doesn't exist yet when
the State object is built. `late` means "work this out the first time someone reads
it". The other way, which you'll see all through the template, is `initState`, the
State's "I've just been created" hook:

```dart
late int _page;

@override
void initState() {
  super.initState();          // always first
  _page = widget.book.currentPage;
}
```

Both run once. Use `initState` when starting up does more than set one field: it's
also where you start listening to things (and `dispose`, its mirror, is where you
stop).

### `setState`: "I changed something, redraw me"

```dart
onChanged: (value) => setState(() => _page = value.round()),
```

Change the field **inside** `setState`. Flutter marks the widget dirty and calls
`build` again on the next frame. Change `_page` without `setState` and nothing
redraws: the number changes, the screen doesn't. This is the single most common
beginner bug, so remember what it looks like.

### The slider: `onChanged` vs `onChangeEnd`

```dart
Slider(
  value: _page.toDouble(),
  max: pages.toDouble(),
  divisions: pages,                    // snap to whole pages
  onChanged: (v) => setState(() => _page = v.round()),   // every frame while dragging
  onChangeEnd: (v) => widget.onPageChanged(v.round()),   // once, when you let go
)
```

While dragging, only the label needs to follow your finger, and that's local state.
The rest of the app only cares where you **stopped**. Reporting every pixel upward
would make the whole app rebuild sixty times a second for nothing.

`Slider` takes doubles, and pages are ints. Convert at the edge (`toDouble()` in,
`round()` out) and keep `_page` an `int`.

### State that lives here vs. state that's reported up

`ReadingProgress` owns `_page` **while you drag**. But the book's real current page
belongs to whoever owns the books. That's `ShelfApp` from day 4, and the view model in
week 3. So `ReadingProgress` doesn't save anything. It calls `onPageChanged` and lets
its parent decide.

That's the pattern for the whole week:

> **Data goes down as constructor arguments. Changes go up as callbacks.**

`BookDetailScreen` follows the same pattern and stays stateless. It doesn't move
books between shelves or delete them. It reports `onStatusChanged(ShelfStatus.done)`
and `onDelete()` up to whoever owns the books.

### Optional callbacks: show the control only if someone's listening

```dart
final VoidCallback? onDelete;
...
actions: [
  if (onDelete case final onDelete?)
    IconButton(icon: const Icon(Icons.delete_outline), onPressed: onDelete),
],
```

`if` inside a list literal adds the item only when the condition holds.
`if (x case final x?)` is Dart's way to say "if it isn't null, and here's the non-null
version". A delete button that does nothing would be a bug, so no callback means no
button.

### When the parent sends new data: `didUpdateWidget`

If the parent rebuilds `ReadingProgress` with a different book, the State survives,
and `_page` would still show the old book's page. Handle it:

```dart
@override
void didUpdateWidget(ReadingProgress old) {
  super.didUpdateWidget(old);
  if (old.book != widget.book) _page = widget.book.currentPage;
}
```

The `!=` here uses the `==` you wrote last week.

### `SegmentedButton` for picking one of a few

```dart
if (onStatusChanged case final onStatusChanged?)
  SegmentedButton<ShelfStatus>(
    segments: [
      for (final status in ShelfStatus.values)
        ButtonSegment(value: status, label: Text(status.label)),
    ],
    selected: {book.status},
    onSelectionChanged: (selected) => onStatusChanged(selected.first),
  ),
```

Inside the `if (… case final onStatusChanged?)`, `onStatusChanged` is the non-null
version, so you can call it. Outside, it's nullable and Dart won't let you.
`selected` is a `Set` because segmented buttons can allow multiple picks. Ours
doesn't, so take `.first`.

---

## Exercises

1. Write `ReadingProgress` in `shelf/lib/ui/book_detail/reading_progress.dart`. The
   doc comment at the top lists the keys and texts. Watch the "cannot go past the last
   page" and "unknown page count" tests.
2. Extend your `BookDetailScreen`. The three callbacks are already declared at the top
   of the class. Add the delete button, the shelf picker, and `ReadingProgress` (only
   for books being read, and only when someone is listening).

```bash
cd shelf
flutter test test/week_02/day_1_test.dart
flutter test test/week_01              # last week must still pass
```

3. Try it on a device. In `main.dart`, pass `onPageChanged: print` and
   `onStatusChanged: print`, run, and watch the terminal as you drag and tap. Notice
   that the chip at the top **doesn't** change when you pick a new shelf. Why not? Who
   would have to change the book? You'll fix it on day 4.

---

## Before tomorrow

- [ ] Weeks 1 and 2-day-1 tests green.
- [ ] **Ship log:** a short screen recording of the slider being dragged.
- [ ] Signal log. In "hardest thing", answer the question from exercise 3.
