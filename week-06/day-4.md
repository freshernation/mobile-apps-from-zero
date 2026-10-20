# Day 4 — Finish: polish and ship

> **By the end of today** your app is something you'd hand to a stranger: every state
> handled, readable by a screen reader, its own icon, a README that gets someone
> running, and a signed release build on your phone.

No new features today. If you're tempted, write it in the README under "what I'd
build next" instead.

## The polish checklist

Go through it in order; each line is on the rubric.

**States** (week 5 day 3)
- [ ] Every screen that loads: loading, error with retry, empty with a sentence that
      says what to do.
- [ ] A failed save shows a message (Command errors through `showErrorsOf`).
- [ ] Airplane mode: open the app, change something, reconnect, and it syncs.

**Everyone**
- [ ] A tooltip on every `IconButton`.
- [ ] Text at 2×: every screen still works.
- [ ] TalkBack or VoiceOver: you can do the demo with your eyes closed.

**Built like the template**
- [ ] No data or rules in any widget. Search your `lib/ui` for repository calls and
      `setState` holding data.
- [ ] Every string in `AppStrings`.
- [ ] `ai/editor.md` run over every file you changed this week.

**Tests**
- [ ] The repository contract runs on the fake and on Firebase fakes.
- [ ] Every rule has a view-model test.
- [ ] One widget test walks your main flow, like Shelf v2's "search to Done to
      deleted".
- [ ] `bash tool/check.sh` green.

**Ship**
- [ ] Icon and launch screen (week 5 day 4).
- [ ] A signed release build on your phone, in the ship log.
- [ ] `README.md`: what it is, a screenshot, **how to run it** (clone, `flutter pub
      get`, Firebase setup), how to run the tests, and what you'd build next.
- [ ] Clone your own repo into a new folder and follow your README. If you get
      stuck, so will your reviewer.

## Rehearse Friday

Read [DEFEND.md](DEFEND.md). Do the demo out loud, start to finish, on the release
build. Then open three random files and explain them to yourself, or to
`ai/defend.md`.

## Before tomorrow

- [ ] Everything above ticked.
- [ ] Committed and pushed to your own repository.
