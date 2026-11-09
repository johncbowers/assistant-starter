---
name: setup
description: First-run setup for a new user of this executive assistant — interviews them about their job, sets up git and a private backup, suggests skills for their kind of work, and turns on the optional parts (scheduled brief, phone capture). Use when CLAUDE.md says SETUP NOT DONE, or when the user asks to redo setup.
---

# Setup

Run this once, in the Claude desktop app's Code tab, with the user watching.
It takes 15–20 minutes. Say what you're doing at each step in one line. Ask
with AskUserQuestion when there are choices; ask in plain chat for free text.
Many users are new to this: explain any term (git, remote, repo) in half a
sentence the first time you use it. Nothing is pushed or created outside this
folder unless the user chooses it.

Start by telling them the plan: "I'll ask about your job, set up a private
backup, and suggest a few things I can track for you. About 15 minutes."

## 1. Git: cut the tie to the starter kit
Git keeps a history of every change to this folder, so nothing is ever lost.
1. `git rev-parse --is-inside-work-tree`. Not a repo (downloaded as a zip) →
   `git init -b main`, then commit everything as `starter kit`.
2. `git remote -v`. If `origin` exists, note its URL (for **Starter kit** in
   CLAUDE.md), then `git remote remove origin`. Tell the user why: this
   folder will hold their own tasks and notes, and must never push back to
   the shared starter. Any other remote: show it and ask before removing.

## 2. About your job
This is an interview, not a form. Ask in chat, two or three questions at a
time, and follow up on anything vague. Cover:
1. Name, job title, team or department, organization.
2. What a typical week looks like. What takes the most time? What do they
   most often forget or scramble on?
3. What repeats: weekly meetings, monthly or quarterly reports, yearly
   cycles (budgets, reviews, conferences, tax season, the school calendar).
   Busy seasons.
4. Who they deal with: a manager, direct reports, clients, vendors,
   students, patients, the public. How they mostly communicate (email,
   Slack/Teams, phone).
5. **Confidentiality:** which of those people are confidential by law,
   contract or common sense (students under FERPA, patients under HIPAA,
   clients under NDA, candidates), and which kinds of information make
   anyone confidential (HR or performance matters, background checks,
   health). Explain rule 4: those people never get named in these files;
   you'll use labels like "Client A".
   Ask whether their employer has a policy on AI tools or on where work
   information may be stored; if they don't know, suggest they find out.
   It matters twice:
   - **What they type.** Rule 4 keeps names out of files, but Claude still
     reads whatever they type. If a policy restricts some information in AI
     tools (patient health information, client data, anything classified),
     say plainly: never type it here at all; describe the work instead
     ("follow-up call for a patient, Friday"). If their employer only allows
     approved AI tools, ask whether this Claude account is one (a personal
     plan may not be); if not, suggest they check before using it for work,
     and track only personal items until then. Record it under
     **Confidential** in CLAUDE.md.
   - **Where the backup goes** (step 4).
6. Personal life too? Some people track family, home and appointments here
   as well; if yes, those items get a `Personal:` label.
7. **How they're evaluated.** Say why you're asking: "Most people write
   their review from memory and forget half of what they did. I can keep
   the record as we go." Then ask: Is there an annual review, self-
   evaluation, activity report, promotion case or OKRs? What period does it
   cover, and when is it due? Does the form have categories or criteria
   (ask them to paste the headings, or the whole form, if they have it)?
   Who reads it? Any goals set at the last review? Anything beyond the
   review itself worth tracking (a license's CE hours, billable hours,
   training required each year, a portfolio)? No formal review (new job,
   freelance)? Recommend the log anyway, with generic categories: it pays
   off in job applications and raise conversations.

Don't ask for anything you won't use. Keep notes in your head until step 5.

## 3. Suggest skills for their job
Follow the `suggest-skills` skill with what you learned in step 2: propose
2–4 skills that fit their work, and offer to build **one** now (the one
they'd use most this month). Note the others under **Skill ideas** in
`ideas.md` so they aren't lost; they can build any of them later with
`/suggest-skills`. During setup, skip suggest-skills' **Finally** steps 1
and 3 (CLAUDE.md, commit, new session): steps 5 and 7 below do them.

## 4. Backup
Explain in two or three sentences: git history lives only on this Mac until
it's pushed somewhere. A backup copy protects against a lost or broken
laptop, but it means the notes also live on that server. (The README's
**Backups** section has the details; point them to it.)

AskUserQuestion: "Where should this folder be backed up?"
- **Private GitHub repo** — easy, works anywhere; your notes live on
  GitHub's servers in a private repository.
- **My organization's server** — a git server your employer runs (GitLab,
  a university server over SSH); stays inside the organization.
- **Local only for now** — nothing leaves this Mac; you can add a backup later.

If their employer restricts where work data may go, list the organization
option first with "(Recommended)" (or local only if they have no
organization server), put GitHub last, and say why in one line.

**GitHub:**
1. `gh --version`. Missing → they can install it (`brew install gh`, or
   https://cli.github.com), or do it by hand (below).
2. `gh auth status`. Not signed in → have them run `gh auth login` in a
   terminal themselves (it opens the browser; you never handle their
   password or token). Retry when they say it's done.
3. Ask the repo name (suggest `assistant`). Check it doesn't exist:
   `gh repo view <name>` must fail. Exists → stop and ask.
4. `gh repo create <name> --private --source . --remote backup`. Then
   `gh repo view <name> --json visibility` must say `PRIVATE`; anything else
   → stop and tell them.
5. Tell them, once: never click **Fork** on the public starter to make their
   copy (forks of public repos are public), and never change this repo to
   public: the whole history becomes readable, including anything later
   deleted.

By hand (no `gh`): they create a new **private**, empty repository on
github.com (no README), copy its SSH or HTTPS URL, and paste it here; then
`git remote add backup <URL>`. A first push that asks for a password → they
need to set up an SSH key or `gh auth login`; they run that, not you.

**Organization server:** ask for the URL their IT gave them (e.g.
`git@gitlab.example.org:me/assistant.git` or `me@server:backups/assistant.git`).
For a plain SSH server with no repo yet: check `ssh -o BatchMode=yes
-o ConnectTimeout=10 <user>@<host> true`. Fails → they need an SSH key and
maybe the VPN; give them `ssh-keygen -t ed25519` and `ssh-copy-id
<user>@<host>` to run themselves (it asks for their password, which you
never handle). Works → `ssh <user>@<host> 'test -e <path> && echo EXISTS ||
git init --bare -q <path>'`; EXISTS → stop and ask. Then `git remote add
backup <URL>`.

`backup` is the only remote this folder ever gets (rule 7).

## 5. Fill the files
- `CLAUDE.md`: copy `.claude/claude-template.md` over it and fill every
  `<…>` from the answers; remove lines for parts they didn't pick. **Starter
  kit** gets the origin URL from step 1 and today's date (or "unknown"). The
  **SETUP NOT DONE** marker must be gone. Add any skill built in step 3 under
  **More procedures** and its tracker under **More files**.
- **Messages:** AskUserQuestion: "When you need to send an email, what
  should I do?" — **Talking points + a blank email (Recommended)**: you
  list what to cover and open an email to the right person; they write it
  in their own words. **Full drafts in my voice**: you write it, they edit
  and send. Record it in **Options**.
- **Mail app:** AskUserQuestion: "Which email do you use for work?" —
  **Gmail in the browser**, **Outlook in the browser**, **A Mac mail app**
  (Apple Mail or desktop Outlook, set as the default). Record it in
  **Options** as `gmail`, `outlook-web` or `mac`; the `draft` skill passes
  it to `scripts/compose.sh`.
- `voice.md`: if they chose full drafts, ask them to paste 2–3 short emails
  they wrote (nothing confidential); one is fine, and they can add more
  later. Fill greeting, sign-off and tone, keep the examples verbatim.
  Otherwise just ask for their usual sign-off.
- `recurring.md`: add the cycles from step 2 as obligations with lead times
  ("Quarterly report — last business day of Mar/Jun/Sep/Dec — start 10 days
  before"), except cycles a skill from step 3 already tracks. Add the key
  dates of their year to **Calendar** if they know them; else `?` (the
  brief asks later).
- `people.md`: ask for a few people they deal with often (manager, close
  colleagues, key contacts), with roles and email addresses. Never
  confidential people.
- `accomplishments/` (unless they declined it in step 2.7): create
  `criteria.md` from the `accomplishments` skill's template with what they
  told you (categories in the form's own words; the generic ones if none),
  and the current period's file with a `# <period>` heading. Add the review
  to `recurring.md` as an obligation: due date, and a lead time of 2 weeks
  ("draft the write-up with `/accomplishments`"). Other things they track
  for evaluation (CE hours, required training) go in as categories with a
  target ("CE hours — 30 by 2027-03-31"). Then ask: "What have you done
  since your last review that you'd want in it?" and log each one. Record
  the period and due date under **Options** in CLAUDE.md.
- `now.md`: ask "What's on your plate this week and next?" and file each
  with the `capture` skill. This is the moment it starts being useful.

## 6. Optional parts
One AskUserQuestion, multiSelect, "Which of these do you want?":
- **Morning brief + Friday review** (scheduled, runs on this Mac)
- **Phone capture** (iPhone shortcut that drops notes into the assistant)
- **Apple Calendar & Reminders sync** (Mac only: tasks show up in
  Reminders, appointments on an Assistant calendar, and the brief reads
  your real calendars)

**Morning brief + Friday review:** if this session has the scheduled-tasks
tool, create two local tasks in this folder:
- "Morning brief", weekdays 7:30 (`30 7 * * 1-5`): "Work in the folder
  <absolute path of this folder>. Follow .claude/skills/morning-brief/SKILL.md.
  This is an unattended run: don't ask questions."
- "Weekly review", Fridays 13:00 (`0 13 * * 5`): same, with
  `.claude/skills/weekly-review/SKILL.md`.
Ask whether those times suit them first. Without the tool, give them the two
prompts to paste on the app's Scheduled page. Then, in plain words: "Open
the Morning brief task and click **Run now** while you watch. The first
time, it will ask permission to change files and save its work; choose
**Always allow** each time, so the 7:30 run doesn't sit waiting for you."
If the Mac is asleep at the scheduled time, the task runs when it wakes.

**Phone capture:** walk them through it on the iPhone:
1. Shortcuts app → **+** → name it **Capture**.
2. Add **Ask for Input** (Text, prompt "Capture").
3. Add **Append to Text File**: file path `phone-inbox.md` (in the Shortcuts
   folder, the default), append *Provided Input*, **Make New Line** on.
4. Add it to the Home Screen or the Action Button.
Have them send a test line; check
`~/Library/Mobile Documents/iCloud~is~workflow~my~workflows/Documents/phone-inbox.md`
(it can take a minute to sync), file it, and empty the file (rule 1).

**Apple Calendar & Reminders sync:** first tell them what it means, in
plain words (the README's **Apple Calendar & Reminders sync** section has
the details; point them to it):
- macOS will ask to give a small helper app full access to Calendars and
  Reminders. It only changes its own "Assistant" calendar and list, but it
  can read all of them.
- The brief will read every calendar on this Mac, including work calendars
  added to the Calendar app, and Claude sees those event titles. Calendars
  they name can be skipped or shown only as "Appointment".
- The Assistant calendar and list go to iCloud, so they reach the phone.
- Change things in the files or by telling the assistant; in Reminders,
  only tick things off (other edits there get overwritten).
Then ask again whether they want it. If yes:
1. `uname -s` must say `Darwin`; otherwise stop: this part is Mac only.
2. `xcode-select -p`. Fails → they need Apple's command line tools: have
   them run `xcode-select --install` themselves and click through the
   installer (a few minutes), then retry.
3. `scripts/apple/build.sh`. It builds `scripts/apple/AssistantSync.app`
   (git-ignored; rebuild after macOS updates if it stops working).
4. Ask whether someone else (a partner, an assistant, a manager) should be
   able to hand them tasks through a shared Reminders list. If yes: its
   name, and a short label for items from it (e.g. `from Sam`). They
   create the list in Reminders and share it themselves.
5. Write `sync/config.json` (`calendar` and `list` stay "Assistant" unless
   they want other names; `shared_list` and `shared_label` from step 4, or
   empty). Run `python3 -I scripts/apple_sync.py sync` while they watch:
   macOS asks for Calendars and Reminders access for "Assistant Sync";
   they click **Allow** for both. Denied by mistake → System Settings ›
   Privacy & Security › Calendars / Reminders, turn on Assistant Sync, run
   again. If the command is refused by the sandbox, run it outside the
   sandbox.
6. List their calendars: `python3 -I scripts/apple_sync.py agenda <today>
   <today+30>` and collect the `[calendar]` names (show names only, not
   events). Ask which to skip entirely (holidays, birthdays, other people's
   shared calendars) and which to show only as "Appointment" (any whose
   event titles name confidential people, rule 4). Put them in `skip` and
   `anonymize` in `sync/config.json`.
7. Check: the Assistant list in Reminders shows their open tasks; the
   Assistant calendar shows `events.md` appointments. Record it under
   **Options** in CLAUDE.md.

## 7. Finish
1. Commit everything (`setup: <first name>`). Backup chosen →
   `git push -u backup main`; failure → say why if you can tell (VPN? key?),
   it goes up next time.
2. Tell them, briefly:
   - Start a **new session** in this folder so the filled-in CLAUDE.md and
     any new skill load.
   - Daily use: tell it things ("Just got an email from my manager: budget
     form due Nov 15"), or type a line into `inbox.md`. Ask "what's on my
     plate next week?". `/draft` for a message, `/suggest-skills` for more
     ideas.
   - New features from the starter kit: say "update the assistant".
