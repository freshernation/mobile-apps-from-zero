# Day 2 — Build: slice by slice

> **By the end of today** your second screen works end to end, with its rules tested,
> and you've committed at least four times.

You have one working slice. Today you add the next one, the same way. The pattern is
the same every time, so use it as a checklist:

## One slice, in order

1. **The rule, as a test.** What does this screen *do* that could be wrong? ("Marking
   a habit done today adds to the streak." "A recipe needs at least one ingredient.")
   Write the view-model test first, on the fake repository.
2. **The view model.** Commands for each action, state for what the screen shows. Make
   the test pass.
3. **The repository**, only if the interface needs a new method. Add it to the
   contract test, then to the fake and the Firebase implementation.
4. **The screen.** It shows and asks, nothing more. Loading, error, empty.
5. **The route.** `_page(...)` and a `Routes` constant.
6. **On your phone.** Ship log.
7. **`check.sh`, commit.** Small commits, each one green.

## Slicing vertically

Build **one whole screen at a time**, not "all the models, then all the screens".
A vertical slice works the moment you finish it, so if Thursday comes early, what you
have *works*, even if there's less of it. Horizontal layers only work when they're
all done.

## Using AI well this week

- Ask it for the **test** first, then read it line by line. Is that actually your
  rule?
- When it writes code, run `ai/editor.md` on it before you commit.
- If it uses something you haven't seen (a package, a pattern, a `Stream` where you'd
  use a Command), stop. Either learn it now, so you can explain it on Friday, or ask
  for the version you know.

## Before tomorrow

- [ ] Two slices end to end, with tests, on your phone.
- [ ] Signal log. Tomorrow's checkpoint uses it.
