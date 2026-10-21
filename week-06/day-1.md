# Day 1 — Start: template to first screen

> **By the end of today** your app is renamed, running on Firebase on your phone, and
> one feature works **all the way through**: you can create a thing, see it in a list,
> and it's still there after you restart the app.

Today is the day most capstones are won or lost, and not by how much gets built. It
depends on whether you get **one thin slice** working end to end before lunch on
day 2. Everything after that is repetition of a pattern you've done twice.

---

## In order

### 1. A new app, in fifteen minutes

```bash
cd ..                                     # next to this course, not inside it
git clone https://github.com/freshernation/mobile-app-template.git my_app && cd my_app
rm -rf .git && git init
dart run tool/rename.dart my_app com.yourname.myapp "My App"
flutter pub get
bash tool/check.sh
git add -A && git commit -m "Start from the template"
```

Set your seed colour in `lib/ui/core/theme.dart`. Commit.

### 2. Firebase, as in week 4 day 2

A **new** Firebase project for this app: Authentication (Email/Password), Firestore,
`flutterfire configure`, deploy `firestore.rules`. Sign up on your phone. Commit.

### 3. Your model: replace `Item`

From `CAPSTONE.md`: your one main class. Write it in `lib/domain/models/`, the way
`Book` is written: immutable, `copyWith`, `==`/`hashCode`, `toJson`/`fromJson`,
`updatedAt`. Write its JSON round-trip test **first**.

### 4. Your repository: replace `ItemRepository`

Interface, Firebase implementation (at `users/{uid}/<your collection>/{id}`, the path
the rules protect), a fake in `testing/fakes/`, and a contract test that runs on
both. Copy the shape of your Shelf v2's `book_repository_contract.dart`. Update
`firestore.rules` if your path changed, and redeploy.

### 5. Your first screen: replace `items`

The template's items list → your list. View model with `load`, screen with loading,
error, empty and the list. Route via `_page`.

### 6. Make it real

Run on your phone. Create one, restart the app, and it's still there. **Ship log.**
Commit.

### 7. Delete what you don't use

The other backends, `items`, anything from the template you've replaced. As in week
4 day 4. `check.sh` green. Commit.

---

## If you're stuck at lunchtime

You should be past step 4. If you aren't, tell your instructor **now**, not tomorrow.
The most common cause is a model that's too big. Cut fields until it's the five you
need for the demo.

## Before tomorrow

- [ ] One feature end to end on your phone, in the ship log.
- [ ] `check.sh` green, committed.
- [ ] Signal log, honestly. Amber today gets you help tomorrow.
