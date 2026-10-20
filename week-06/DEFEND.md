# Capstone defense

Thirty minutes. Your app's **release build** on your phone, your repository open, and
`CAPSTONE.md` to hand.

This is what the course has been building toward. You're showing two things:
**you built this**, and **you could build the next one without us**.

---

## 1. Demo (5 min)

The day 5 demo from `CAPSTONE.md`, on the release build. Then turn on airplane mode
and show what still works.

## 2. Explain any line (10 min)

Your instructor opens files and points. For each one you say what it does, why it's
there, and what would break without it. Expect at least:

- your model's `fromJson`, and what happens with a missing field;
- your Firebase repository, and the matching line in `firestore.rules`;
- one view-model rule, and its test;
- one screen's states, and where each one comes from;
- one line an AI wrote for you, and what you'd have written instead.

"I don't know, the AI wrote it" fails the line. "I don't know, but here's how I'd
find out" passes, once.

## 3. Change it live (15 min)

Your instructor asks for a small change: a new field, a rule, a sort order, a
validation. You:

1. say where it goes, in which layers;
2. write the test first;
3. make it pass;
4. run `check.sh`;
5. show it on the phone.

AI is allowed, the same as all week. Fifteen minutes is enough when the
architecture is clean. That's the point of the exercise.

## What passes

The same list as the [week 6 README](README.md): it runs, it's built like the
template, it's tested, it's for everyone, it has a README, and you can defend it. Your
instructor marks each one in front of you, with a reason.
