---
name: morning-brief
description: Write the user's weekday morning brief from the files in this folder. Use only when running the scheduled morning brief or when the user explicitly asks for today's brief.
---

# Morning brief

## Guard (do this first)
- Get the current local date and time with a shell command (`date`).
- If it is Saturday or Sunday, stop.
- If `briefs/<today>.md` already exists, stop and say so.
- If it is after 2:00 pm, write the **short version**: only *Today* and
  anything due tomorrow. Skip the rest.

This may be an unattended run. Don't ask questions; anything that needs the
user's input goes under **Needs a decision**.

## Steps
1. **Triage the inboxes.** If Apple sync is on (CLAUDE.md), first run
   `python3 -I scripts/apple_sync.py sync`: it brings in items from the
   shared list and ticks off what was done in Reminders. Then the phone
   inbox (if CLAUDE.md has one), then
   `inbox.md`. File each line using the `capture` skill's rules and delete it
   from its inbox. Anything you can't place goes to `now.md` **Unsorted**.
2. **Read** `now.md`, `events.md` and `recurring.md`.
   - **Events:** today's go at the top of **Today**, one line each with
     times. With Apple sync on, use the user's real calendars instead:
     `python3 -I scripts/apple_sync.py agenda <today> <today+6>` (it
     includes `events.md`, which the sync put on the Assistant calendar).
     Calendar titles follow rule 4. Point out a clash with a deadline, or
     a packed day this week.
   - **Recurring:** work out each obligation's next date and, from its lead
     time, the date to start. Start date or due date within 5 working days
     → **This week** (or **Today**), saying which ("start today: quarterly
     report, due 11-20"). If one depends on a date
     marked `?` that could fall in the next 8 weeks, ask for it under
     **Needs a decision**.
3. **The user's own skills** (CLAUDE.md **More procedures**): for each,
   follow its **What's due** section against its tracker. Collect steps that
   are overdue, due today, or due in the next 5 working days, and anything
   missing. They go under a heading named for the skill.
4. **Move** items in `now.md` between **Due this week** and **Coming up** so
   the sections are accurate for today.
5. **Write the brief** to `briefs/YYYY-MM-DD.md`:

   ```
   # <Weekday>, <Month D>

   ## Today
   (today's events, with times; then overdue, with how many days; then due today)

   ## <Skill name>
   (one section per skill with something due, one line per action, with its
    date; these aren't repeated under This week)

   ## This week
   (due in the next 5 working days)

   ## Waiting on
   (only items waiting 5+ working days)

   ## Needs a decision
   (Unsorted items, conflicts, anything you couldn't file)

   ## Messages to write
   (each message due today or overdue: who to, then talking points, per the
    `draft` skill. Don't open compose windows in an unattended run.)
   ```

   Leave out any section with nothing in it. Keep everything above
   **Messages to write** under about 25 lines. No pep talk, no filler.
6. **Print** the brief in the session as well, so it shows in the run output.
   If CLAUDE.md says the brief goes to the phone, also write it to
   `~/Library/Mobile Documents/com~apple~CloudDocs/Assistant/brief.md`
   (iCloud Drive › Assistant; create the folder if missing), replacing the
   previous day's. It's outside git.
7. If anything changed in `now.md` or `events.md` during the brief and
   Apple sync is on, run the sync again. Commit (`brief: YYYY-MM-DD`) and
   push if there's a backup (rule 7).
