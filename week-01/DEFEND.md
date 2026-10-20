# Week 1 — Friday defense

Twenty minutes, on your own code, with your instructor. Have Shelf running on a device
and `book.dart`, `sample_books.dart` and `book_detail_screen.dart` open.

You're not being tested on memory. You're being tested on whether you can **explain
what you wrote** and **change it without breaking it**. If you can do that, you can do
it on any app.

---

## 1. Explain (5 min)

1. In `Book`, why is `pageCount` an `int?` but `title` a plain `String`? What would go
   wrong if `pageCount` defaulted to `0` instead?
2. Walk through `progress` for a book with `pageCount: null`, then `0`, then
   `currentPage` past the end. Which line handles each one?
3. You overrode `==`. Why did you also have to override `hashCode`? Name something
   that breaks if you don't.
4. What's the difference between `final`, `const` and `var`? Point to one of each in
   your code, or say why there isn't one.
5. In `titleOrError`, where is the `await`, and why does it have to be inside the
   `try`?
6. On your detail screen, point at one layout choice you made (a gap, an `Expanded`,
   a text style) and say what it's for.

## 2. Change it (8 min)

Say what you'll change first, then type.

- **A.** "Books can have a rating from 1 to 5, or none." Add it to `Book`: the field,
  the constructor, `copyWith`, `==`, `hashCode` and JSON. Which test would you write
  first?
- **B.** "Show how many hours the book takes to read, under the page count." You
  wrote the function on day 1. Use it.

## 3. Break it (5 min)

- Without running it: remove the `errorBuilder` from the cover image, and open the
  screen with no network. What happens? Now try it.
- Without running it: delete `hashCode` from `Book`, keep `==`, and run
  `{dune, dune.copyWith()}.length`. What do you expect, and why?

## 4. Ship (2 min)

Show your ship log: the counter app with hot reload, and your detail screen on a device.
