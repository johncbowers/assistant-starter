---
name: talks
description: Manage the user's talk series — add or update a talk, record a title/abstract/bio received, check what's due, or prepare the speaker request, follow-up, announcement or day-of reminder.
---

# Talk series

Tracker: `talks.md` (repo root). Templates: `templates/` next to this file.
Series defaults (day, time, room, mailing list) are in `talks.md` **Rules**.

## Add or update
- New talk → add a row: date, speaker, affiliation, host; Title/Abstract/Bio/
  Room and Asked/Announced/Reminder all `—`. Keep rows sorted by date.
- Title, abstract or bio received → mark `✓` in the table and put the full
  text under **Details** in `talks.md`. Never paraphrase or "improve" a
  speaker's abstract.
- Talk cancelled or moved → update the row and say so in **Notes**.

## What's due
For each upcoming talk, compute the steps from the lead-time rules in
`talks.md` **Rules**. Count calendar days; a step that lands on a weekend
moves to the Friday before. A step is due if its date has come and its
column isn't `✓`. Also flag what's missing (title, abstract, bio, room) once
the announcement is 7 days or less away.

## Messages
- **Request and follow-up** (to the speaker): talking points and a blank
  email, per the `draft` skill. `templates/request.md` lists what the request
  must cover; use it as a checklist, not as text.
- **Announcement and reminder** (to the mailing list): the user's own
  template, `templates/announcement.md`, filled from the tracker. It's their
  wording; you fill only the facts. Unknowns stay in `[BRACKETS]`. **Never
  invent** a title, abstract, bio, room or time.

## Marking done
Mark Asked / Announced / Reminder `✓` only after the user says it was sent.
After the talk, write `held` in **Notes** and move the row under **Past**.
