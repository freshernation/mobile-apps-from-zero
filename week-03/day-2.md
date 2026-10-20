# Day 2 — A place for the logic: the view model

> **By the end of today** `ShelfApp` no longer owns a list, no longer needs
> `_change` or `_router.refresh()`, and every week 2 test still passes. The books and
> the rules about them live in a `ShelfViewModel` that every screen shares.

Yesterday the data got a home. Today the **logic** does: "moving a book to Done puts
you on the last page", "a page can't go past the end", "save first, then show". Last
week those rules were scattered through `ShelfApp` callbacks. Today they move into one
class you can test without a single widget.

This is **MVVM**, the pattern Flutter's own architecture guide recommends:

```
 View        (widget)            shows state, forwards taps. No rules.
   │ listens / calls
 ViewModel   (ChangeNotifier)    holds state, applies rules, exposes Commands
   │ calls
 Repository  (yesterday)         gets and saves data
```

---

## Read first

- [ ] [UI layer](https://docs.flutter.dev/app-architecture/case-study/ui-layer) · 20 min
- [ ] [Simple app state management](https://docs.flutter.dev/data-and-backend/state-mgmt/simple): `ChangeNotifier`, `ChangeNotifierProvider` and `Consumer` · 20 min

---

## What you need to know

### A view model is a `ChangeNotifier` with Commands

```dart
class ShelfViewModel extends ChangeNotifier {
  ShelfViewModel({required this._repository}) {
    load = Command0(_load)..execute();       // load once, straight away
    setPage = Command1(_setPage);
  }

  final BookRepository _repository;
  List<Book> _books = [];
  List<Book> get books => _books;

  late final Command0<void> load;
  late final Command1<void, ({String id, int page})> setPage;
  ...
}
```

`late final Command0<void> load;` is a field that's set
exactly once, in the constructor body, and can't be read before then. The commands
need `this` (they call `_load`), which only exists inside the constructor body, so
they can't be set in the field declaration.

`required this._repository` assigns a private field, and the parameter is still
called `repository` from outside.

`({String id, int page})` is a **record**: a quick, typed bundle of values with no
class needed. `Command1` takes one argument, so two values travel together as one
record: `setPage.execute((id: '1', page: 200))`.

### Save first, then show

```dart
Future<Result<void>> _save(Book book) async {
  final result = await _repository.updateBook(book);
  if (result case Ok(:final value)) {
    _books = [for (final b in _books) b.id == value.id ? value : b];
    notifyListeners();
  }
  return result;
}
```

The screen only changes once the repository says the change is saved. If saving
fails, nothing on screen pretends it worked, and the Command holds the `Error` for
the screen to show.

`_books` is **replaced**, never edited in place. You used the same idea with `Book`
and `copyWith` in week 1: a new list is a change everyone can see.

### The rules live here

```dart
Future<Result<void>> _setStatus(({String id, ShelfStatus status}) change) {
  final book = bookById(change.id);
  if (book == null) {
    return Future.value(const Result.error(NotFoundException()));
  }
  return _save(book.copyWith(
    status: change.status,
    currentPage: change.status == ShelfStatus.done
        ? (book.pageCount ?? book.currentPage)
        : book.currentPage,
  ));
}
```

On Friday's week 2 defense you were asked where "Done means last page" belongs. This
is the answer: next to the data, where every screen gets it for free and one unit
test covers it.

### Sharing one view model: `provider`

```dart
@override
Widget build(BuildContext context) {
  return ChangeNotifierProvider.value(
    value: _shelf,
    child: MaterialApp.router(routerConfig: _router, ...),
  );
}
```

Everything below the provider can reach `_shelf`:

```dart
Consumer<ShelfViewModel>(
  builder: (context, shelf, _) => ShelfScreen(books: shelf.books, ...),
)

context.read<ShelfViewModel>().add.execute(book);   // in a callback: just call it
```

`Consumer` **listens**: when the view model calls `notifyListeners()`, that builder
runs again. `context.read` **doesn't listen**. Use it in callbacks, where you want to
call something, not redraw.

Now look at what disappeared: no `_change`, no `_router.refresh()`. The detail
screen's builder is inside a `Consumer`, so a new page number redraws it, because
the view model says so, not because you remembered to.

### A widget that is *handed* a view model: `ListenableBuilder`

`Consumer` finds the view model through the provider above it. Tomorrow's search
screen works differently: it's **given** its view model in the constructor
(`SearchScreen(viewModel: vm)`), and its tests build it with no provider at all, so
`Consumer` and `context.watch` would throw "Could not find the correct Provider".
For a widget holding its own reference, listen directly:

```dart
ListenableBuilder(
  listenable: viewModel,                 // anything that notifies
  builder: (context, _) => Text('${viewModel.books.length} books'),
)
```

A `Command` is a `ChangeNotifier` too, and it's the thing that knows "running" and
"failed". To redraw when **either** the data **or** the command changes, merge them:

```dart
ListenableBuilder(
  listenable: Listenable.merge([viewModel, viewModel.search]),
  builder: (context, _) {
    if (viewModel.search.running) return const CircularProgressIndicator();
    if (viewModel.search.error) return const Text('Failed');
    return ResultsList(viewModel.results);
  },
)
```

Listen only to the view model and you'll never see the spinner or the error: the
view model calls `notifyListeners()` when results arrive, but it's the Command
that changes when a search starts or fails. The template uses this pattern on
every screen.

### The screens didn't change

`ShelfScreen`, `BookDetailScreen` and `AddBookScreen` are untouched. They still take
data and report taps. That's why every week 2 test still passes: you changed *where
the state lives* without changing *what the user sees*, and the tests prove it.

---

## Exercises

1. Write `ShelfViewModel` in `lib/ui/shelf/shelf_view_model.dart`. Replace the stub's
   getters with `late final` fields, as above. Add `dispose()` to dispose every
   Command.
2. Rework `ShelfApp` in `lib/app.dart`:
   - Create one `ShelfViewModel` (on `widget.repository`, or
     `InMemoryBookRepository(initial: sampleBooks)` if none), and dispose it in
     `dispose`.
   - Provide it above `MaterialApp.router`.
   - Wrap the shelf and detail builders in `Consumer<ShelfViewModel>`, and wire every
     callback to a Command.
   - Delete `_books`, `_change` and `_update`.

```bash
cd shelf
flutter test test/week_03/day_2_test.dart
flutter test test/week_01 test/week_02     # must still pass — this is the real test
```

3. **The payoff, felt:** the "moving a book to Done" rule now has a unit test that runs
   in milliseconds with no widgets. Count how many week 2 widget tests you'd have
   needed to cover the same rules.

---

## Before tomorrow

- [ ] Weeks 1, 2 and 3-days-1–2 all green.
- [ ] Signal log. In "hardest thing", say which line of last week's `ShelfApp` you're
      happiest to have deleted, and why.
