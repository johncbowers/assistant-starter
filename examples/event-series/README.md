# Example skill: a talk series

A complete custom skill, generalized from a real one a professor uses to run
a weekly research seminar. It shows the pattern `suggest-skills` builds:

| Piece | File | Holds |
|---|---|---|
| Procedure | `SKILL.md` | How to add a talk, what's due when, which message goes with which step. No dates or names: it works every year. |
| Tracker | `talks.md` | The data: the series' rules (lead times, room) and one row per talk. |
| Templates | `templates/` | A checklist for the speaker request, and the user's own announcement with blanks. |

How it pays off in practice:
- "Sam sent his title and abstract" → the row gets `✓`s and the text goes
  under **Details**, verbatim.
- The morning brief, three weeks before a talk: "Talks: ask Priya
  Natarajan for title/abstract/bio (talk 2026-12-04)."
- A week out: "Talks: announcement due today; bio still missing." Ask for it
  and the assistant fills the announcement template from the tracker,
  leaving `[BIO — verbatim]` blank rather than inventing one.

## Using it

This folder is outside `.claude/skills/`, so it doesn't load. To use it as is:

```
mkdir -p .claude/skills/talks
cp -R examples/event-series/SKILL.md examples/event-series/templates .claude/skills/talks/
cp examples/event-series/talks.md talks.md
```

then clear the example rows from `talks.md`, add
`` - `talks` — the talk series (tracker: `talks.md`) `` under **More
procedures** in CLAUDE.md, and start a new session. Or say "build me a skill
like the talk-series example for <your thing>" and `suggest-skills` will
interview you and adapt it.
