# Day 3 — For everyone: every state, every platform, every reader

> **By the end of today** every screen in Shelf has an answer for "loading", "it
> failed" and "there's nothing here". It looks at home on iOS and Android, and it
> works with a screen reader and with large text.

An app that only works on your phone, with your eyesight, on good wifi, isn't
finished. None of today's work is hard. All of it is the difference between a
project and a product, and it's what Friday's defense and your capstone are graded
on.

---

## Read first

- [ ] [Accessibility](https://docs.flutter.dev/ui/accessibility-and-internationalization/accessibility): the whole page · 20 min
- [ ] [Automatic platform adaptations](https://docs.flutter.dev/ui/adaptive-responsive/platform-adaptations): skim · 10 min
- [ ] [Material 3 adaptive constructors](https://api.flutter.dev/flutter/material/AlertDialog/AlertDialog.adaptive.html): `AlertDialog.adaptive` · 5 min

---

## What you need to know

### Three states, every screen that loads

| State | What the user sees | In Shelf |
|---|---|---|
| Loading, nothing yet | a progress indicator | `load.running` and no books |
| Failed, nothing yet | what went wrong and a **Retry** button | `shelf-error` with `retry` (the template's `ErrorView`) |
| Loaded, but empty | a sentence that says what to do | `empty-shelf` |

And one more that's easy to forget: **failed, but you already have data**. A pull to
refresh on a train mustn't wipe the shelf you were looking at. Keep the books you
have and show the error in a SnackBar, not instead of the list.

### Screen readers read what you tell them

TalkBack (Android) and VoiceOver (iOS) read the screen aloud. Flutter builds the
spoken version from your widgets, and the gaps are always in the same places:

- **Icon buttons need a tooltip.** An `IconButton(icon: Icon(Icons.qr_code_scanner))`
  is read as "button", nothing more. `tooltip: 'Scan a barcode'` is read aloud, and
  shows on a long press too. Every icon button in Shelf gets one, and there's a test
  that checks every screen.
- **Say what a value means.** A slider is read as "14%" by default. Shelf's slider
  should say "Page 120 of 832":
  ```dart
  Slider(
    ...,
    semanticFormatterCallback: (value) => 'Page ${value.round()} of $pages',
  )
  ```
  Use `AppStrings.pageOf(page, count)`, the same text as the label above it.

**Try it on a phone:** Android, Settings → Accessibility → TalkBack. iOS, Settings →
Accessibility → VoiceOver. Close your eyes and add a book. You'll find things no test
will.

### Large text

People turn text size up, a lot. Your layout must survive it:

```dart
tester.platformDispatcher.textScaleFactorTestValue = 2.0;   // in a test
```

The fixes are the ones from week 1: `Expanded` around text in a `Row`, a `ListView`
instead of a `Column` for anything that might grow, and never a fixed height on
something holding text. Don't shrink the user's text back down. They chose it.

### At home on both platforms

Most Material widgets already adapt: scrolling physics, back gestures, fonts. A few
things look wrong on iOS if you leave them Material, and **dialogs** are the most
visible. `.adaptive` constructors pick the platform's own version:

```dart
final confirmed = await showAdaptiveDialog<bool>(
  context: context,
  builder: (context) => AlertDialog.adaptive(
    title: const Text(AppStrings.deleteConfirmTitle),
    actions: [ ...cancel and delete actions... ],
  ),
);
```

The actions should be adaptive too: `CupertinoDialogAction` on iOS (with
`isDestructiveAction: true` for Delete, which makes it red), and `TextButton`
elsewhere. Write a small `_DialogAction` widget that picks by
`Theme.of(context).platform`, and keep the `confirm-delete` key on it. Other
`.adaptive` widgets worth knowing: `Switch.adaptive`, `Checkbox.adaptive`,
`CircularProgressIndicator.adaptive()`.

Tests pretend to be iOS with `debugDefaultTargetPlatformOverride = TargetPlatform.iOS`.

---

## Exercises

1. Walk every screen: shelf, book, search, scan. Write down which of the three states
   each one handles, and fix the gaps.
2. A tooltip on every `IconButton`.
3. The slider's `semanticFormatterCallback`.
4. The adaptive delete dialog.

```bash
flutter test test/week_05/day_3_test.dart
```

5. **On a device:** TalkBack or VoiceOver on, add a book by search with your eyes
   closed. Then text size to the maximum, and visit every screen.

---

## Before tomorrow

- [ ] Days 1–3 green; `check.sh` green.
- [ ] **Ship log:** a screenshot of Shelf at the largest text size; a short recording
      of VoiceOver or TalkBack reading the book screen; the delete dialog on iOS and
      Android side by side.
- [ ] Signal log. In "hardest thing", name one thing the screen reader taught you that
      no test did.
