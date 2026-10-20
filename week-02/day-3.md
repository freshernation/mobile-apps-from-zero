# Day 3 — Forms: taking input you can't trust

> **By the end of today** you can add a book by hand: a form that says exactly what's
> wrong before it lets you save, and hands back a clean `Book`.

Every app eventually asks the user to type something, and users type everything:
spaces before a title, `abc` for a page count, a trailing comma after an author. A
form's job is to turn that into data the rest of your app can trust, and to say
kindly and specifically what's wrong when it can't.

---

## Read first

- [ ] [Build a form with validation](https://docs.flutter.dev/cookbook/forms/validation) · 10 min
- [ ] [Retrieve the value of a text field](https://docs.flutter.dev/cookbook/forms/retrieve-input) · 10 min
- [ ] [Handle changes to a text field](https://docs.flutter.dev/cookbook/forms/text-field-changes): skim · 5 min

---

## What you need to know

### `Form` + `TextFormField` + a key

```dart
final _formKey = GlobalKey<FormState>();
...
Form(
  key: _formKey,
  child: ListView(children: [
    TextFormField(
      controller: _title,
      decoration: const InputDecoration(labelText: 'Title'),
      validator: (value) => (value == null || value.trim().isEmpty) ? 'Required' : null,
    ),
    // more fields
  ]),
)
```

A `validator` returns an error message, or `null` when the value is fine. Nothing
runs until you ask:

```dart
void _save() {
  if (!_formKey.currentState!.validate()) return;   // shows every error at once
  // every field is valid here
}
```

`validate()` runs every validator, shows every message under its field, and returns
whether all of them passed. The `GlobalKey` is how you reach the form's state from
your save button.

### Controllers hold the text, and must be disposed

```dart
final _title = TextEditingController();

@override
void dispose() {
  _title.dispose();
  super.dispose();
}
```

A controller holds listeners and resources. Create it in your State and dispose it
in `dispose`, every time. A forgotten `dispose` doesn't crash: it leaks a little memory
on every visit to the screen, and nobody notices for months. Make it a habit now.

### Parse, don't trust

```dart
String? _pageCount(String? value) {
  final text = value?.trim() ?? '';
  if (text.isEmpty) return null;                    // optional: empty is fine
  final pages = int.tryParse(text);                 // null for 'abc' or '12.5'
  return (pages == null || pages <= 0) ? 'Enter a whole number above 0' : null;
}
```

`int.tryParse` returns `null` instead of throwing, so you get a nullable value and
handle it, as on day 2 of last week. `keyboardType: TextInputType.number` shows a
number keypad, but **it's a convenience, not validation**: people can still paste
anything. Always validate.

### Clean up on the way out

```dart
title: _title.text.trim(),
authors: [
  for (final author in _authors.text.split(','))
    if (author.trim().isNotEmpty) author.trim(),
],
```

`for` and `if` inside a list literal build the list in place. `'A,B ,'.split(',')` gives
`['A', 'B ', '']`. Trim each one and drop the empties.

### The form doesn't save anything

`AddBookScreen` has no idea where books live. It validates, builds a `Book`, and
calls `onAdd(book)`, the same pattern as the last two days. Where the book goes is
tomorrow's problem, and the owner's.

---

## Exercises

1. Write `AddBookScreen` in `shelf/lib/ui/add_book/add_book_screen.dart`, with three
   `TextFormField`s, three controllers (disposed!), and a save button in the app bar.
   The doc comment has every key and message.

```bash
cd shelf
flutter test test/week_02/day_3_test.dart
```

2. On a device, use the keyboard's "next" key to move between fields
   (`textInputAction: TextInputAction.next`), and make "done" on the last field save.
   This isn't tested. It's the difference between a form that works and one that's
   pleasant.
3. Think it through, no code: the id is `DateTime.now().microsecondsSinceEpoch`. When
   could two books get the same id? Does it matter for Shelf? (It will in week 4, when
   the server makes the ids.)

---

## Before tomorrow

- [ ] Tests green, including everything before.
- [ ] **Ship log:** a screenshot of the form showing all three error messages at once.
- [ ] Signal log.
