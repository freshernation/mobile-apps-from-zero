# Day 4 — Screens that connect: navigation, theme, and who owns the books

> **By the end of today** Shelf is a real app. It opens on your shelf, you tap a book
> to open it, move it between shelves, add and delete books, and it follows your
> phone into dark mode.

Every screen you've built reports changes **up** through callbacks: `onAdd`,
`onStatusChanged`, `onDelete`. Today you build the thing at the top that receives
them: `ShelfApp`. It owns the one list of books, and it connects the screens with a
**router**.

---

## Read first

- [ ] [Navigation and routing](https://docs.flutter.dev/ui/navigation): the overview · 10 min
- [ ] [go_router: Get started](https://pub.dev/documentation/go_router/latest/topics/Get%20started-topic.html) and [Navigation](https://pub.dev/documentation/go_router/latest/topics/Navigation-topic.html) · 20 min
- [ ] [Use themes to share colors and font styles](https://docs.flutter.dev/cookbook/design/themes) · 10 min

---

## What you need to know

### A router maps paths to screens

```dart
final _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => ShelfScreen(...)),
    GoRoute(path: '/add', builder: (context, state) => AddBookScreen(...)),
    GoRoute(
      path: '/book/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        // find the book, show it
      },
    ),
  ],
);

MaterialApp.router(routerConfig: _router, ...)
```

Every screen has an address, like a web page. `:id` is a **path parameter**: for
`/book/42`, `state.pathParameters['id']` is `'42'`. Week 5's notifications use those
addresses: a push carries `/book/42`, and tapping it opens that book.

Keep paths in one place (`lib/routing/routes.dart`) and navigate with
`Routes.book(book.id)`, never with a hand-typed string. A typo in a string is a
screen nobody can reach, and the compiler can't tell you.

### `push` vs `go`

```dart
context.push(Routes.book(book.id));   // on top: back returns here
context.go(Routes.home);              // jump: replaces the stack to match that path
context.pop();                        // back one
```

Use `push` for "open this, then come back" (a book, the add form). Use `go` to land
somewhere definite. After saving a new book, `go(Routes.home)` always lands on the
shelf, even if someone deep-linked straight to `/add`.

### An unknown id is a normal case

`/book/42` after 42 was deleted, or a stale notification, or a mistyped link: the
book isn't there. Don't use `!` on it and crash. Show a screen that says so:

```dart
final book = _bookWithId(id);
if (book == null) return const _BookNotFound();
```

### `ShelfApp` owns the books

```dart
class _ShelfAppState extends State<ShelfApp> {
  final List<Book> _books = [...sampleBooks];
  ...
  BookDetailScreen(
    book: book,
    onStatusChanged: (status) => _update(book.copyWith(status: status)),
  )
```

This is "lifting state up": the books live in the **lowest widget that every screen
needing them sits under**, which here is the top of the app. Data flows down through
constructors and changes flow up through callbacks into `_books`.

Now the honest part. Today's tests include "moving a book to another shelf updates
the open screen". With only `setState`, it fails. `setState` rebuilds `ShelfApp`, but
go_router only re-runs its page builders (the code that reads `_books`) when the
router itself is told to refresh. So every change needs both:

```dart
void _change(VoidCallback change) {
  setState(change);
  _router.refresh();
}
```

It works. But look at what you now have to know: where the books live, that every
change must go through `_change`, and that forgetting the second line gives a screen
that silently shows old data. With three screens this is manageable. With thirty,
it's where most bugs come from. **Week 3 removes all of it.** For now, feel the
weight. On Friday you'll be asked what hurts about it.

### A theme from one colour

```dart
ThemeData shelfTheme(Brightness brightness) => ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(seedColor: shelfSeed, brightness: brightness),
);

MaterialApp.router(
  theme: shelfTheme(Brightness.light),
  darkTheme: shelfTheme(Brightness.dark),   // used when the phone is in dark mode
  ...
)
```

`ColorScheme.fromSeed` works out a whole palette (primary, surfaces, containers,
error) from one colour, in light and dark versions that both pass contrast checks.
Change the seed and the whole app re-colours. That's why you never hard-code
`Colors.brown` in a screen. Ask `Theme.of(context).colorScheme` instead.

---

## Exercises

1. `shelf/lib/ui/core/theme.dart`: write `shelfTheme`.
2. `shelf/lib/app.dart`: write `ShelfApp`. It owns `_books`, has three routes and the
   not-found screen, and wires every callback.
3. `shelf/lib/main.dart`: `runApp(const ShelfApp());`

```bash
cd shelf
flutter test test/week_02/day_4_test.dart
flutter test test/week_01 test/week_02     # everything so far
```

4. **Feel it on purpose:** take `_router.refresh()` out of `_change` and run the tests.
   Which fail, and why exactly those? Put it back.
5. On a device: switch the phone to dark mode while Shelf is open.

---

## Before tomorrow

- [ ] Weeks 1 and 2 all green.
- [ ] **Ship log:** a short screen recording of the whole flow: add a book, open it,
      move it to Reading, drag the progress, delete it. Light and dark mode.
- [ ] Signal log.
- [ ] Read `week-02/DEFEND.md`.
