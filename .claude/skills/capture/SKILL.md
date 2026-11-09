---
name: capture
description: Record something new the user reports — an email they got, a request, a deadline, a task, an appointment, something finished, an idea for later ("I just got an email about X", "add Y", "remind me to Z", "done with W"). Use whenever the user hands you information to track.
---

# Capture

1. **Restate** the item to yourself in one line with absolute dates. If it
   clearly needs a due date and none was given, ask once. If the user doesn't
   know, file it without one.
2. **Strip confidential details** (rule 4, CLAUDE.md **Confidential**) before
   writing anything.
3. **File it** in exactly one place:
   - Covered by one of the user's own skills (CLAUDE.md **More
     procedures**) → follow that skill (usually a row in its tracker).
   - Appointment with a date and time (meeting, call, trip) → `events.md`
     in its format. If it also means work beforehand (RSVP, prepare
     slides), that task goes in `now.md` too.
   - Task or deadline → `now.md`, in **Due this week** if due within 7 days,
     else **Coming up**: `- [ ] item — due YYYY-MM-DD (added YYYY-MM-DD)`.
     Personal items (if the user tracks them here) start with `Personal:`.
   - Waiting on someone → `now.md` **Waiting on others**:
     `- [ ] what — from whom — waiting since YYYY-MM-DD`.
   - New standing obligation ("every quarter I have to…") → `recurring.md`.
   - Idea for later, no due date ("someday I'd like…") → `ideas.md` under
     the matching heading: `- idea in one line (added YYYY-MM-DD)`, with the
     user's details indented beneath it. Keep their wording.
   - Something finished → change its `[ ]` to `[x]` and append
     `— done YYYY-MM-DD`. Leave it in place; the weekly review archives it.
   - Can't tell → `inbox.md` as `- YYYY-MM-DD: <what the user said>`.
   - **Also, people:** a new colleague or contact with a role → add or update
     their line in `people.md`. Never confidential people.
4. If the same item already exists, update that line instead of adding a new
   one.
5. If the item means the user owes someone a reply, **offer** to prepare it
   with the `draft` skill. Don't do it unasked.
6. If the same kind of item keeps coming in (third time this month, say),
   mention once that a skill could handle it (`suggest-skills`).
7. **Confirm** in one short line what you filed and where. Commit if this is
   a git repo (rule 7).

Several items in one message: file each one, then confirm them together.
