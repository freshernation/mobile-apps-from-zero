# The AI roles

You get one AI, and it plays several characters. Which one you open matters more
than what you type into it.

| Role | File | When |
|---|---|---|
| **Tutor** | [tutor.md](tutor.md) | You're stuck, and twenty minutes have passed |
| **Editor** | [editor.md](editor.md) | Your tests pass and you want to know if the code is any *good* |
| **Planner** | [planner.md](planner.md) | Week 5 day 4: planning your capstone |
| **Defend** | [defend.md](defend.md) | Thursday evening, before Friday's defense |

Any capable chat assistant works. Use the one you're comfortable with.

## How to use one

Open a **fresh chat**. Paste the whole role file as your first message, filling in
the `[SQUARE BRACKETS]` at the top. Then talk normally.

**Start a new chat for each session.** A chat that's been running for days has
drifted from its instructions and is quietly back to being a generic assistant.

## The one thing that ruins this

> "Just fix it for me."

In weeks 1–3, typing that gets you working code and teaches you nothing. Six weeks
later you'd own an app you can't explain, and Friday's defense is built to find
exactly that. The tutor is written to refuse this. Don't go around it by opening a
plain chat: the only person that cheats is you.

From week 4 the AI **may** write code with you. The rule becomes: you may not commit a
line you could not have written and cannot explain on Friday. The editor is how you
check.

## What goes in your log

Every role ends its session by printing a `SIGNAL` block. Copy its line into
[logs/signal-log.md](../logs/signal-log.md). It takes ten seconds, and it's how your
instructor knows where to spend tomorrow's live hour.
