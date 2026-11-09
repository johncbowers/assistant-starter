---
name: weekly-review
description: Friday weekly review — archive finished items, keep now.md within its limit, flag stale items and look two weeks ahead. Use only for the scheduled Friday review or when the user explicitly asks for a weekly review.
---

# Weekly review

## Guard
- Get the current local date (`date`). If `briefs/<today>-review.md` already
  exists, stop.
- This may be an unattended run. Don't ask questions; put anything that needs
  the user under **Needs a decision**.

## Steps
1. **Inbox.** File anything left in `inbox.md` (capture skill rules).
2. **Archive.** Move every `[x]` line from `now.md` to `archive/YYYY-MM.md`
   (month of completion), under a `## Week of YYYY-MM-DD` heading, and every
   `events.md` line whose date has passed (under the same heading).
3. **Stale check.** List items added 14+ days ago that have no due date, or
   whose due date has passed and aren't done. **Don't delete them.** List
   them under **Stale?** so the user can decide.
4. **Length.** If `now.md` is over 40 lines, list candidates to archive or
   drop under **Needs a decision**. Don't drop anything yourself.
5. **The user's own skills** (CLAUDE.md **More procedures**): instances whose
   date has passed → mark them done in the tracker the way the skill says (or
   move them under a **Past** heading). List each skill's steps due in the
   next 10 working days.
6. **Look ahead.** Everything due in the next 10 working days, by date,
   including recurring obligations and events.
7. **Patterns.** If the same kind of item came in three or more times this
   week and no skill covers it, add one line under **Needs a decision**:
   "Might be worth a skill: <what> (`/suggest-skills`)." At most one per
   review.
8. **Write** the review to `briefs/YYYY-MM-DD-review.md` with sections:
   **Done this week**, **Look ahead**, **Stale?**, **Needs a decision**.
   Leave out empty sections. Print it in the session too.
9. Commit (`review: YYYY-MM-DD`) and push if there's a backup (rule 7).
