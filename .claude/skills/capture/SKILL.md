---
name: capture
description: Record something new the user reports — an email they got, a request, a deadline, a task, an appointment, something finished, an idea for later ("I just got an email about X", "add Y", "remind me to Z", "done with W"). Use whenever the user hands you information to track.
---

# Capture

1. **Restate** the item to yourself in one line with absolute dates. If it
   clearly needs a due date and none was given, ask once. If the user doesn't
   know, file it without one.
2. **Strip confidential details** (rule 4, CLAUDE.md **Confidential**) before
   writing anything. If the user typed something CLAUDE.md says should
   never be typed here (employer policy), file the item without it and
   remind them once per session, in one line, to leave such details out.
3. **File it** in exactly one place:
   - Covered by one of the user's own skills (CLAUDE.md **More
     procedures**) → follow that skill (usually a row in its tracker).
   - Appointment with a date and time (meeting, call, trip) → `events.md`
     in its format (`Personal:` label too, if it's personal). If it also
     means work beforehand (RSVP, prepare slides), that task goes in
     `now.md` too. With Apple sync on, check the user's calendars first
     (`python3 -I scripts/apple_sync.py agenda <date>`): if it's already
     there, don't add it to `events.md`; just say so.
   - Task or deadline → `now.md`, in **Due this week** if due within 7 days,
     else **Coming up**: `- [ ] item — due YYYY-MM-DD (added YYYY-MM-DD)`.
     Personal items (if the user tracks them here) start with `Personal:`.
   - Waiting on someone → `now.md` **Waiting on others**:
     `- [ ] what — from whom — waiting since YYYY-MM-DD`.
   - New standing obligation ("every quarter I have to…") → `recurring.md`.
     Exact date unknown → write `?` for it; the brief asks once it matters.
   - Idea for later, no due date ("someday I'd like…") → `ideas.md` under
     the matching heading: `- idea in one line (added YYYY-MM-DD)`, with the
     user's details indented beneath it. Keep their wording.
   - Something finished → change its `[ ]` to `[x]` and append
     `— done YYYY-MM-DD`. Leave it in place; the weekly review archives it.
   - Can't tell → `now.md` **Unsorted** (rule 6), in the user's words with
     the date added; the next brief asks about it.
   - **Also, people:** a new colleague or contact with a role → add or update
     their line in `people.md`. Never confidential people.
   - **Also, accomplishments** (if `accomplishments/` exists): anything that
     would belong in their review (a result delivered, a talk or training,
     a launch, praise, an award, a goal reached, a new responsibility) →
     add an entry per the `accomplishments` skill, with a guessed category.
     Say which category in the confirmation. Don't ask first.
4. If the same item already exists, update that line instead of adding a new
   one.
5. If the item means the user owes someone a reply, **offer** to prepare it
   with the `draft` skill. Don't do it unasked.
6. If the same kind of item keeps coming in (third time this month, say),
   mention once that a skill could handle it (`suggest-skills`).
7. **Confirm** in one short line what you filed and where. Commit if this is
   a git repo (rule 7).
8. **Apple sync** (if CLAUDE.md says it's on): after filing, run
   `python3 -I scripts/apple_sync.py sync` so Calendar and Reminders match,
   and mention anything new it brought in.

Several items in one message: file each one, then confirm them together.
