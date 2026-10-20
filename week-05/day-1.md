# Day 1 — The camera: scan a book to add it

> **By the end of today** you point your phone at the barcode on the back of a book,
> and it's on your Want to read shelf. You know how an app asks for the camera on
> Android and iOS, and what happens when the user says no.

This is the first thing in the course a website can't do. It's also the first time
Shelf asks the user for **permission**, and permission is the part to get right.

---

## Read first

- [ ] [mobile_scanner](https://pub.dev/packages/mobile_scanner): the README, *Usage* and *Platform setup* · 15 min
- [ ] [App permissions on Android](https://developer.android.com/guide/topics/permissions/overview): the overview · 10 min
- [ ] [Requesting access to protected resources (iOS)](https://developer.apple.com/documentation/uikit/requesting-access-to-protected-resources) · 10 min
- [ ] [ISBN](https://en.wikipedia.org/wiki/ISBN): *Check digits* only · 5 min

---

## What you need to know

### Adding a plugin

```bash
flutter pub add mobile_scanner:7.4.2
```

A **plugin** is a package with native Android and iOS code inside it. After adding
one, stop the app and run it again. Hot reload can't load new native code.

### Asking for the camera, per platform

The two platforms ask differently, but neither lets you skip asking:

| | What you add | When the user is asked |
|---|---|---|
| **iOS** | In `ios/Runner/Info.plist`: `NSCameraUsageDescription` with a sentence saying *why*, e.g. "Shelf scans the barcode on a book to add it to your shelf." | The first time the camera starts. Without the key, the app **crashes** the moment the camera opens. |
| **Android** | Nothing: the plugin's own manifest declares `android.permission.CAMERA`, and the build merges it into yours. | The first time the camera starts. |

Write the iOS sentence for the user, not for Apple's reviewer. It's the text on the
dialog, and it's what makes someone tap Allow.

### "No" is a normal answer

Users deny permissions all the time, and on iOS, after one "no" the app can never
show the dialog again. Only the Settings app can change it. Plan for three outcomes:

```dart
MobileScanner(
  onDetect: _onDetect,
  errorBuilder: (context, error) => Text(
    error.errorCode == MobileScannerErrorCode.permissionDenied
        ? 'Shelf needs the camera to scan. Allow it in Settings → Shelf → Camera.'
        : 'No camera here. Type the ISBN instead.',
  ),
)
```

And always give a way forward without the camera. Shelf's scan screen has a text
field where you can type the ISBN. That's also how you test on the iOS Simulator,
which has no camera.

### A barcode is not always an ISBN

The camera reports **every** barcode it sees, many times a second: QR codes, a
supermarket barcode on the coffee cup behind the book, a digit misread in bad light.
Only ISBNs should reach Open Library. An ISBN carries its own check, the last digit:

- **ISBN-13** starts with `978` or `979`. Multiply the digits by 1, 3, 1, 3… and the
  total must be a multiple of 10.
- **ISBN-10** (older books): multiply by 10, 9, 8… 1 (`X` means 10), and the total
  must be a multiple of 11. Convert it to ISBN-13 by putting `978` in front of the
  first nine digits and working out a new check digit.

Write `isbnFrom(raw)` in `lib/ui/scan/isbn.dart`. It returns the ISBN-13, or `null`
for anything else. It ignores spaces and hyphens, so `978-0-441-17271-9` works.

### Looking it up

Open Library's search takes an ISBN too, and gives back the same kind of result you
already parse:

```
https://openlibrary.org/search.json?isbn=9780441172719&fields=key,title,author_name,number_of_pages_median,cover_i
```

Add `Future<Result<Book?>> byIsbn(String isbn)` to your `OpenLibraryService`. It
returns `Ok(null)` when Open Library has no match: "not found" isn't a failure of the
network.

### The scan view model

`ScanViewModel({service, books})` has one Command, `onBarcode` (a
`Command1<Book?, String>`):

| The barcode is… | Result |
|---|---|
| not an ISBN | `Ok(null)`, and nothing is sent anywhere |
| an ISBN already found a moment ago | the same `Ok(book)` again, with no new request (the camera sees it 30 times a second) |
| an ISBN Open Library knows, for a book **already on your shelf** | that book, **unchanged**, `Ok(book)`: re-adding it would reset your page and move it back to Want to read |
| an ISBN Open Library knows | the book is added on **Want to read**, `Ok(book)` |
| an ISBN Open Library doesn't know | `NotFoundException`, and while it stays in view it isn't asked about again |
| no connection | `NetworkException`, and scanning again retries (a failed connection isn't remembered, an answer is) |

To check "already on your shelf", ask your repository with `getBook(id)`: `Ok` means
it's there; `NotFoundException` means add it.

Put the view model in `lib/ui/scan/scan_view_model.dart` and `isbnFrom` in
`lib/ui/scan/isbn.dart`. The tests import them from there.

The screen shows the result under the camera: a progress bar while looking up,
"Added *Dune* to Want to read" with an **Open** button, or the error. Add a scan
button to the shelf's app bar (`open-scan`, an `IconButton` with a tooltip) that opens
`Routes.scan` (`/scan`).

---

## Exercises

1. `isbnFrom`, then `byIsbn`, then `ScanViewModel`. The tests drive all three:
   ```bash
   mkdir -p test/week_05 && cp ../week-05/tests/day_1_test.dart test/week_05/
   flutter test test/week_05/day_1_test.dart
   ```
2. `ScanScreen` (camera, ISBN field, result), the route, the shelf button, and the iOS
   camera sentence.
3. **On a phone:** scan five real books. Then deny the camera (uninstall, reinstall,
   tap Don't Allow) and check your message appears and the ISBN field still works.
4. **On the iOS Simulator:** no camera. Type `9780441172719`.

---

## Before tomorrow

- [ ] Day 1 green; `check.sh` green.
- [ ] **Ship log:** a recording of a real scan adding a book, and a screenshot of the
      permission-denied message.
- [ ] Signal log. In "hardest thing", explain why the view model ignores a barcode it
      has just found.
