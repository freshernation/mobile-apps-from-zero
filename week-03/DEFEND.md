# Week 3 — Friday defense (Project 2)

Twenty minutes, on your own code. Have Shelf running on a device and `app.dart`,
`shelf_view_model.dart`, `book_repository_sqlite.dart` and `open_library_service.dart`
open.

---

## 1. Explain (6 min)

1. Draw the layers on paper: screen → view model → repository → database / server.
   Point to one file in each.
2. Follow a tap on "Done" again, as you did last week. What changed, and where did
   `_change` and `_router.refresh()` go?
3. `setStatus` saves first and only then updates the screen. What would the user see
   if it did it the other way round and the save failed?
4. Why does `OpenLibraryService` take an `http.Client` in its constructor?
5. Every way your search can fail: name them, and show the line that handles each.
6. `Command.execute` while it's already running: what happens, and what bug does that
   prevent?
7. Why does the `/search` route make its `SearchViewModel` inside
   `ChangeNotifierProvider(create: …)` instead of directly in the builder?

## 2. Change it (8 min)

Say what you'll change first, then type.

- **A.** "Add a 'Clear finished' button that deletes every book on Done." Which layer
  gets the new method? Write its test first.
- **B.** "Keep the books in memory again, but start with no sample books." How many
  files do you change? (The answer is one line.)

## 3. Break it (4 min)

- Without running it: `getBooks` in `InMemoryBookRepository` returns `_books` instead
  of a copy. Write the three lines of code that would corrupt the shelf from outside.
- Without running it: you remove `.timeout(...)` from the search. When would a user
  notice, and what would they see?

## 4. Ship (2 min)

Your ship log: a real search, the airplane-mode error, and a book surviving a restart.
