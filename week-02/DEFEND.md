# Week 2 — Friday defense (Project 1)

Twenty minutes, on your own code. Have Shelf running on a device and `app.dart`,
`book_detail_screen.dart` and `reading_progress.dart` open.

---

## 1. Explain (6 min)

1. Where do the books live? Follow one tap on "Done" in the shelf picker, from the
   button to the chip changing. Name every function it passes through.
2. `ReadingProgress` keeps its own `_page`. Why not just use `book.currentPage`? And why
   doesn't it save the page itself?
3. Why `onChangeEnd` and not `onChanged` for reporting the page upward?
4. What does `_router.refresh()` do in your `ShelfApp`? What breaks without it, and why
   doesn't `setState` cover it?
5. Why is `ShelfScreen` stateful but `BookDetailScreen` stateless?
6. Name every controller you created this week, and where each one is disposed.

## 2. Change it (8 min)

Say what you'll change first, then type.

- **A.** "The shelf screen shows a count on each segment: *Reading (2)*." Where does
  the count come from, and does anything need to be stored?
- **B.** "Marking a book Done should set its page to the last page." Where does that
  rule go: the picker, `BookDetailScreen`, or `ShelfApp`? Defend your answer, then do
  it.

## 3. Break it (4 min)

- Without running it: you call `_books.add(book)` without `_change` / `setState`. What
  does the user see, and when does it "fix itself"?
- Without running it: a notification opens `/book/42` for a book deleted yesterday.
  What happens in your app?

## 4. Ship (2 min)

Your ship log: one book's whole life on a device, in light and dark mode.
