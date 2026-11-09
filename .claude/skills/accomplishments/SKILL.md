---
name: accomplishments
description: Keep a running record of the user's accomplishments for their performance review, annual report, promotion case or self-evaluation — log entries against their evaluation criteria, confirm categories, show gaps, and draft the write-up at review time. Use for /accomplishments, "what have I done this year", review or self-evaluation prep, or to check how entries are categorized.
---

# Accomplishments

Most people write their annual review from memory in a panic, and forget
half of what they did. This skill keeps the record as the year goes, sorted
by what their evaluation actually asks for, so the write-up is mostly done
when it's due.

Files, in `accomplishments/`:
- `criteria.md` — how the user is evaluated (filled at setup; see below).
- `<period>.md` — one file per review period, named for it (`2026.md`,
  `2026-h2.md`, `fy27.md`). A new period starts as a copy of the heading of
  the last one.
- `evidence/<period>/` — documents they'll attach or cite (certificates,
  thank-you notes, published work, slides). Never anything about
  confidential people (rule 4).

## criteria.md

```
# How I'm evaluated

- Process: <annual review | self-evaluation form | promotion dossier | OKRs | …>
- Period: <calendar year | fiscal year Jul–Jun | …>
- Due: <when the write-up is due, e.g. "first Friday of December"; ? if unknown>
- Who reads it: <manager, committee, …>
- Form or system: <where it's submitted, what format it wants>

## Categories
<!-- In the form's own words. One line each, with what counts as evidence. -->
- <Category> — <what counts>

## Goals for this period
<!-- Goals set at the last review, if any. Entries link to them. -->
```

Unknown categories (no form, first job) → start with generic ones and say
so: **Results** (what you delivered), **Growth** (skills, training,
certifications), **Collaboration** (helping others, cross-team work),
**Leadership & initiative** (things you started or ran), **Recognition**
(praise, awards). The user can rename them anytime.

## Entry format
One `##` block per accomplishment, in the file for the period it happened in:

```
## Short title in plain words
- date: YYYY-MM-DD (or YYYY-MM for something that ran a while)
- category: <a category from criteria.md>
- status: guess | confirmed
- goal: <a goal from criteria.md, if it advances one>
- what: one or two lines of facts
- impact: numbers or outcomes the user gave (people reached, time saved,
  money, a quote from feedback); ? if none yet
- evidence: evidence/<period>/<file> | a link | ?
- added: YYYY-MM-DD
```

- Facts only, from the user or the files. Never invent an outcome, number or
  quote; `?` instead, and ask about it at review time.
- Confidential people (rule 4): counts and labels, never names ("mentored 2
  new hires", "Client B renewed").
- `status: confirmed` only when the user agrees with the category.

## Adding entries
The `capture` skill adds an entry whenever something it files counts:
something finished that delivered a result, a talk or training given or
taken, a project launched, praise received, an award, a goal reached, a
new responsibility. In addition to wherever else it's filed. Guess the
category, mark `status: guess`, and say which category in the confirmation
line ("logged for your review under Results"). Don't ask first.

When the user says something vague ("the launch went well"), file what
they said and ask once for one number or outcome; `?` if they don't know.

Evidence: when the user gives you a document or link for an entry, copy
the file to `evidence/<period>/` (keep its name; leave the original) or
put the link on the `evidence:` line.

## /accomplishments
With no other request: show the current period, by category, one line per
entry; then **To confirm** (entries with `status: guess`); then **Thin**
(categories or goals with fewer than two entries) and **Missing impact**
(entries with `impact: ?`). Under 30 lines.

## At review time
`recurring.md` holds the review as an obligation with a lead time (setup
adds it). When it comes due, or when the user asks:
1. Confirm guesses: list them and ask, in one message, for any category
   changes.
2. Ask for the `?` impacts, in one message.
3. Draft the write-up in `accomplishments/<period>-draft.md`, in the
   structure `criteria.md` says the form wants (by category, by goal, or
   free text), in the user's voice (`voice.md`), first person, short and
   factual. Every claim comes from an entry; no entry, no claim. Put the
   strongest items first in each section.
4. Add **Next period's goals**: suggestions from `ideas.md`, open items in
   `now.md` and **Thin** categories, marked as suggestions; the user decides.
5. Show the draft. The user edits and submits it themselves (rule 5);
   never mark the review as submitted unless they say so. Afterward, start
   the next period's file and copy their new goals into `criteria.md`.
