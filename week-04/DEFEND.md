# Week 4 — Friday defense

Twenty minutes, on Shelf v2. Have it running on a device, signed in, and the Firebase
console open.

From this week some of your code may have been written with AI. That's allowed. What
isn't is a line you can't explain, and your instructor will point at lines at random.

---

## 1. Explain (6 min)

1. Your `NOTES.md` map: pick two rows and say what the template's version does that
   your week 3 version didn't.
2. A user taps **Done** on a book. Follow it from the button to Firestore: which view
   model, which rule function, which repository, which document path.
3. Why are Firestore writes started and not awaited in `BookRepositoryFirebase`? What
   would the user see on a train if they were awaited?
4. Read your `firestore.rules` aloud. What stops another user reading your shelf, even
   if they write their own app against your Firebase project?
5. Why does each screen's view model come from `_page(...)` in the router? What bug
   happens without it?
6. Your answers to the three-backend reading questions: where does each backend stop
   user B reading user A's data?

## 2. Change it (8 min)

Say what you'll change first, then type (AI allowed, and you explain every line it
writes).

- **A.** "Show how many books are on each shelf in the filter: *Reading (2)*." Which
  file changes? Is anything stored?
- **B.** "A book can have a 1–5 rating." Every layer it touches, in order: model, JSON,
  repository (does it change?), view model, screen. Which test do you write first?

## 3. Break it (4 min)

- In the console's Rules Playground: what does `allow read, write: if true;` let a
  stranger do? Show it.
- Without running it: delete `refreshListenable: auth` from the router. Sign out.
  What happens?

## 4. Ship (2 min)

Your ship log: two-device sync, and the airplane-mode change syncing afterwards.
