---
name: suggest-skills
description: Suggest new skills that fit the user's job, and build the one they pick — a tracker file plus a procedure, like a seminar-series or hiring-pipeline skill. Use during setup, when the user runs /suggest-skills, asks "what else could you track for me?", or says "make a skill for X".
---

# Suggest and build skills

A skill is a written procedure for one recurring part of the user's job. The
built-in skills (capture, brief, review, draft) handle loose to-dos. A custom
skill earns its place when something **repeats with the same steps**, has
**several moving parts per instance**, or has **deadlines that count back from
a date**. Example: a talk series, where every talk needs a speaker asked 3
weeks out, a room booked, and an announcement sent a week before.

See `catalog.md` next to this file for patterns by kind of job, and
`examples/event-series/` in the repo root for one complete skill.

## Suggest
1. Read CLAUDE.md **About the user**, `recurring.md`, `now.md`, `ideas.md`
   **Skill ideas**, and the user's existing skills (**More procedures**).
   During setup, use the interview instead.
2. Look for work that matches the test above. Good signals: "every
   month I have to…", the same kind of item showing up in `now.md` again
   and again, a process with a checklist, things they said they forget.
3. Propose 2–4, most useful first. For each, one short paragraph:
   - **Name** (one or two lowercase words, e.g. `hiring`, `client-projects`).
   - What it would track and what it would do for them ("reminds you to
     follow up with each candidate 5 days after an interview; drafts the
     talking points").
   - Why it fits, in their terms ("you said you run 3–4 searches a year").
   Don't propose a skill for something the built-in skills already handle
   (a one-off deadline is just a `now.md` item).
4. AskUserQuestion: which one to build now (or none). Ideas not built go in
   `ideas.md` under **Skill ideas**, one line each.

## Build
Interview first, then write. Ask in chat, a few questions at a time:
1. **The unit.** What's one instance? (One talk, one hire, one client
   project, one report.) What facts does each have? These become the
   tracker's columns. Keep it to what they'd actually look up; 6–10 columns.
2. **The steps.** What happens for each instance, in order, and how long
   before (or after) its key date? These become lead-time rules ("Ask for
   materials: 21 days before"). If they don't know, propose defaults and
   label them as defaults they can change.
3. **The messages.** Which steps mean writing to someone? For each, what
   must the message cover? These become checklist templates, not scripts:
   the user writes their own words (rule 5) unless CLAUDE.md says full drafts.
   If they have a template they already use for announcements or similar
   mass messages, paste it in verbatim; fill-in-the-blanks from the user's
   own template is fine.
4. **Confidentiality.** Does any column name a confidential person (rule 4)?
   Then that column holds a label ("candidate #3"), never a name.

Then create:
- **Tracker** `<name>.md` in the repo root: a short **Rules** section with
  the lead times (data the user can edit), a table with one row per instance
  (dates `YYYY-MM-DD`, `—` for not yet, `✓` for done), and a **Details**
  section for long text (abstracts, notes) that doesn't fit a table cell.
- **Skill** `.claude/skills/<name>/SKILL.md`, with front matter (`name`, and
  a `description` that says what it handles and the words the user would
  use to ask for it), and these sections:
  - **Add or update** — how a new instance or a change gets filed.
  - **What's due** — how to compute each step's date from the lead-time
    rules (count calendar days; a step that lands on a weekend moves to the
    Friday before) and what counts as missing. The morning brief and weekly
    review follow this section.
  - **Messages** — which template goes with which step; facts from the
    tracker only, unknowns in `[BRACKETS]`, never invented.
  - **Marking done** — a step is `✓` only when the user says so (rule 5).
- **Templates** (if any) in `.claude/skills/<name>/templates/`.

The procedure must work every year without edits: no dates, names, rooms or
other specifics in the SKILL.md. Those are data and go in the tracker's
**Rules** section or in CLAUDE.md.

Finally:
1. Add the skill under **More procedures** in CLAUDE.md
   (`- \`<name>\` — <what it handles> (tracker: \`<name>.md\`)`) and the
   tracker under **More files**.
2. Ask for the current instances ("which hires are open right now?") and
   file them, so it's useful today.
3. Commit (`skill: <name>`), push if there's a backup. Tell the user to start
   a new session so the skill loads, then try it: "`/<name>` what's due?".
