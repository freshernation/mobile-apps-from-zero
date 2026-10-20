# Day 2 — Accounts in the cloud: Firebase

> **By the end of today** Shelf v2 has a real Firebase project behind it. You can
> create an account on your phone, sign out, sign in again on another device, and
> you've locked the database so nobody can read anybody else's data.

Yesterday's app ran against a little server on your laptop. Real apps need accounts
that work from any phone, data that syncs, and a database that's safe to put on the
internet. Building that yourself is months of work. **Firebase** is Google's
ready-made version, with a free plan that's far more than a course (or a first app)
needs.

There's very little code today. Most of it is setup, and setup is where people lose
days, so go slowly and read every screen.

---

## Read first

- [ ] [Add Firebase to your Flutter app](https://firebase.google.com/docs/flutter/setup) · 20 min
- [ ] [Get started with Firebase Authentication on Flutter](https://firebase.google.com/docs/auth/flutter/start) · 10 min
- [ ] [Get started with Cloud Firestore Security Rules](https://firebase.google.com/docs/firestore/security/get-started): the introduction · 10 min

---

## What you need to know

### One project, two apps

A **Firebase project** is the box in the cloud: accounts, database, push. Inside it
you register your **apps**, one Android and one iOS, by their app ids. You set those
ids yesterday with `rename.dart`, which is why that came first.

### The two command-line tools

```bash
npm install -g firebase-tools           # the Firebase CLI (needs Node.js)
dart pub global activate flutterfire_cli
firebase login
```

### Setup, in order

1. In the [Firebase console](https://console.firebase.google.com), **add a project**
   called "Shelf". Google Analytics: off (you don't need it).
2. **Authentication → Get started → Sign-in method → Email/Password → Enable.**
3. **Firestore Database → Create database.** Pick a location near you. Start in
   **production mode**. You'll deploy real rules in a minute.
4. From `shelf_v2/`:
   ```bash
   flutterfire configure
   ```
   Pick the project and both platforms. This registers both apps and **replaces
   `lib/firebase_options.dart`**, the file that said "Run: flutterfire configure".
5. Deploy the security rules that came with the template:
   ```bash
   firebase init firestore      # use the existing firestore.rules when it asks
   firebase deploy --only firestore:rules
   ```
6. `flutter run` (that's `main.dart`, the Firebase entry point) and create an account.

Open **Authentication → Users** in the console: your account is there. Sign in on a
second device (or the emulator and the simulator) with the same account.

### Security rules: the database's front door

```
match /users/{uid}/{document=**} {
  allow read, write: if request.auth != null && request.auth.uid == uid;
}
```

Read it out loud: "anything under `users/{uid}` can be read and written only by the
signed-in user whose id is `uid`". Everything else is denied. Your app's code
already only asks for your own data, but **the app isn't the security**. Anyone can
call Firebase directly with your project's id. Rules are what actually stop them.

"Test mode" (everything open for 30 days) is how most leaked databases happen.
Never ship it, and don't develop in it either.

### What didn't change

Look at `lib/data/repositories/auth/auth_repository_firebase.dart` next to
`auth_repository_rest.dart`. Same interface: the router, the sign-in screen and its
view model don't know or care which one is running. Yesterday's app on REST and
today's on Firebase are the same app above that line.

---

## Exercises

1. The setup above, all six steps.
2. Sign up on one device, sign in on another.
3. **Try to break in:** in the Firestore console, open **Rules → Rules Playground**.
   Simulate a `get` of `/users/someone-else/books/x` as an authenticated user with a
   different uid. It should be denied. Then simulate your own uid: allowed.
4. Read `auth_repository_firebase.dart` top to bottom. Find where a Firebase error
   becomes the app's `AuthException`, and why the screen never sees Firebase's own
   error type.

There are no new tests today. The template's auth tests already cover the code. Today
is about the cloud side, which only a real device proves.

---

## Before tomorrow

- [ ] `bash tool/check.sh` is still green.
- [ ] **Ship log:** your account in the Firebase console, and the app signed in on two
      devices.
- [ ] **Ship log:** a screenshot of the Rules Playground denying the other uid.
- [ ] Signal log.
