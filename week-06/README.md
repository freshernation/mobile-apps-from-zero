# Week 6 — Your app

> **By Friday** you've built an app of your own, from an empty folder to a release
> build on your phone, in five days, and you can explain every line of it to someone
> who points at it at random. That's the whole course, proven.

No guided app this week, no tests written for you, no lesson that tells you what to
build. You have the template, `CAPSTONE.md` (signed off last Friday), and five weeks
of everything you've done.

The rule from week 4 stands, and it matters most now:

> **AI may write code with you. You may not commit a line you could not have written
> and cannot explain on Friday.**

## The week

| Day | | By the end of the day |
|---|---|---|
| 1 | [Start: template to first screen](day-1.md) | Your app renamed, on Firebase, and **one** feature working end to end on your phone: model → repository → view model → screen |
| 2 | [Build: slice by slice](day-2.md) | Your second screen, end to end, with tests |
| 3 | [Checkpoint](day-3.md) | Third screen started; **checkpoint with your instructor**; scope cut if you're behind |
| 4 | [Finish: polish and ship](day-4.md) | States, accessibility, icon, README, release build, every test green |
| 5 | **Defense** | [DEFEND.md](DEFEND.md): demo, explain, change it live |

## Passed when

| | |
|---|---|
| **It runs** | A clean clone, followed by your README's steps, runs on a phone. A release build is in your ship log. |
| **It's built like the template** | Model → repository → view model → screen. No data or rules in widgets. One view model per screen, made with `_page`. Strings in `AppStrings`. |
| **It's tested** | A repository contract test (your fake and your Firebase repository), view-model tests for every rule, and at least one widget test of your main flow. `bash tool/check.sh` green. |
| **It's for everyone** | Loading, error and empty states on every screen that loads. Tooltips on icon buttons. Survives 2× text. |
| **It has a README** | What it is, a screenshot, how to run it (including Firebase setup), and what you'd build next. |
| **You can defend it** | [DEFEND.md](DEFEND.md): explain any line, and make a small change live in 15 minutes. |

The detailed scoring your instructor uses is the same list, out loud. There are no
hidden criteria.

## Where it lives

Your capstone is its own repository, not a folder in this one. On day 1 you clone
the template into a new folder next to this course, and that becomes a new git repo,
yours to keep, publish and show.
