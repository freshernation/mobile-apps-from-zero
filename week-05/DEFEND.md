# Week 5 — Friday defense (Project 3)

Twenty-five minutes: twenty on Shelf, five on your capstone plan. Have the **release
build** on a real phone, and `CAPSTONE.md` open.

---

## 1. Explain (7 min)

1. The camera sees a QR code, then the coffee cup's barcode, then a book's ISBN 30
   times in a second. Walk through what `ScanViewModel` does with each, and how many
   requests reach Open Library.
2. Prove `9780441172719` is a valid ISBN-13 by hand: the weights and the total.
3. Your app asked for the camera and the user said no. What do they see on iOS? Can
   your app ask again?
4. A push arrives with `route: /books/OL893414W`. Follow it from the tap to the
   screen, and say what happens if the route were `/admin`, or the book was deleted.
5. What does a screen reader say for your scan button, and where did that text come
   from?
6. Debug vs release build: name three differences. What would happen if you lost your
   upload key?

## 2. Change it (8 min)

Say what you'll change first, then type. AI allowed; you explain every line.

- **A.** "Scanning a book that's already on my shelf should jump straight to its page,
  instead of showing 'Added'." Which classes change? Write the test first.
- **B.** "The reminder should only fire on weekdays." What does the notification
  plugin offer? Where does the change go?

## 3. Break it (3 min)

- Without running it: remove `NSCameraUsageDescription` from `Info.plist`. What
  happens on iOS when the scan screen opens?
- Without running it: `isbnFrom` accepts any 13 digits. What would users notice?

## 4. Ship (2 min)

The release build on your phone, and your ship log.

## 5. Capstone (5 min)

Walk through `CAPSTONE.md`: the sentence, the model, the three screens, the day 5
demo, and what you're not building. Expect at least one cut.
