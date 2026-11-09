# Executive Assistant (starter kit)

A personal executive assistant that lives in a folder on your Mac and runs on
[Claude Code](https://claude.com/claude-code). You tell it what's going on
("my manager wants the budget form by Nov 15"), and it keeps track: to-dos,
deadlines, appointments, recurring obligations, who's waiting on whom. Each
weekday morning it writes you a short brief of what needs doing. When you
need to write to someone, it lists what to say and opens a blank email.

It's built for people early in their careers who are starting to juggle
more than a to-do app can hold, and it adapts to your job: on day one it
interviews you about your work and suggests **skills**, small procedures
for the parts of your job that repeat (a talk series, a hiring pipeline,
client check-ins, quarterly reports).

It has **no access to your email, calendar or accounts.** It knows what you
tell it, and it keeps everything as plain Markdown files in this folder,
with every change saved in git.

## What you need

- A Mac with the [Claude desktop app](https://claude.ai/download) and a
  Claude plan that includes Claude Code. (The scheduled brief and the phone
  shortcut are Mac/iPhone features; the rest works anywhere Claude Code runs.)
- Git. On a Mac, typing `git` in Terminal offers to install it if it's missing.
- 20 minutes for setup.
- Optional: a GitHub account, for a private backup (see **Backups**).

## Get started

1. **Copy the kit to your Mac.** In Terminal:

   ```bash
   git clone https://github.com/johncbowers/assistant-starter.git ~/Documents/Assistant
   ```

   (Or download the ZIP and unzip it to `~/Documents/Assistant`.) Don't use
   GitHub's **Fork** button: a fork of a public repo is public, and this
   folder will hold your notes.

2. **Open it in Claude.** In the Claude desktop app, go to the **Code** tab,
   start a new session, choose the `Assistant` folder, and say "hi".

3. **Do the interview.** It sees that setup hasn't been done and walks you
   through it:
   - cuts the link back to this starter repo, so your notes can never be
     pushed here;
   - asks about your job: what a typical week looks like, what repeats, who
     you work with, what's confidential;
   - suggests 2–4 skills for your kind of work and builds one with you;
   - sets up a private backup, if you want one;
   - asks what's on your plate this week and files it;
   - optionally schedules the morning brief and a Friday review, and sets
     up an iPhone shortcut for capturing things on the go.

4. **Start a new session** in the folder (so your new settings load) and use it.

## Using it

Talk to it like you'd talk to an assistant. Some examples:

| You say | It does |
|---|---|
| "Just got an email from Dana: the budget form is due Nov 15." | Adds a to-do due `2026-11-15` to `now.md`. |
| "Meeting with the vendor Thursday at 2." | Adds it to `events.md` with the date worked out. |
| "I asked IT for a new laptop, still waiting." | Files it under **Waiting on others**; the brief nudges you if it sits too long. |
| "Every quarter I have to send the board a usage report." | Adds a recurring obligation with a lead time, so it shows up in the brief 10 days ahead every quarter. |
| "Done with the budget form." | Checks it off; Friday's review archives it. |
| "What's on my plate next week?" | Reads the files and tells you, by day. |
| "Help me reply to Dana about the deadline." / `/draft` | Lists the points to cover and opens a blank email to Dana. You write it. |
| "Someday I'd like to start a reading group." | Saves it in `ideas.md`, out of the daily brief. |
| `/suggest-skills` | Looks at what you've been tracking and suggests a skill. |

You can also just type a line into `inbox.md` (or from your phone, with the
Capture shortcut); the next brief files it.

**The morning brief** lands in `briefs/YYYY-MM-DD.md` each weekday:

```
# Tuesday, November 10

## Today
- 10:00–11:00 Team standup prep — Room 4B
- OVERDUE 2 days: expense report for the October trip
- Due today: send slides to Dana

## Talks
- Ask Priya for title/abstract/bio (talk 2026-12-04)

## This week
- Thu 11-12: quarterly usage report to the board (start today)

## Needs a decision
- "Call about the lease" — personal or work? Due when?
```

**The Friday review** archives what's done, flags items that have gone
stale, keeps `now.md` short, and looks two weeks ahead.

## Skills

A skill is a written procedure, a `SKILL.md` file in `.claude/skills/`,
that the assistant follows for one kind of task. You can call one directly
with `/name`, or just describe what you want.

**Built in:** `capture` (file what you tell it), `morning-brief`,
`weekly-review`, `draft` (talking points or a draft), `suggest-skills`,
`setup`, `update-assistant`.

**Your own.** The built-in skills handle loose to-dos. A custom skill earns
its place when something in your job **repeats with the same steps**, has
**several moving parts each time**, or has **deadlines that count back from
a date**. Each one is a procedure plus a tracker file with one row per
instance. Some examples of what people build:

| Your job involves… | A skill could… |
|---|---|
| Running a talk or event series | Ask speakers 3 weeks out, chase missing abstracts at 2 weeks, fill your announcement template at 1 week. (Full example in [`examples/event-series/`](examples/event-series/).) |
| Hiring | Track each candidate by label and stage; remind you to follow up 5 days after an interview. |
| Clients or projects | Track each engagement's next deliverable and invoice date; nudge you when you haven't checked in for 2 weeks. |
| Managing people | Keep topics to raise at each 1:1 and when you last met. |
| Grant, report or proposal deadlines | Work back from the due date: internal deadline, budget, letters of support. |
| Looking for a job | Track applications, last contact, and when to follow up. |
| Reviews, references, favors | Keep a queue of what you agreed to and when it's due. |

Say `/suggest-skills`, or "make me a skill for tracking client projects",
and it interviews you (what's one instance? what are the steps and when?
which steps mean writing to someone?) and builds it. More patterns are in
[`.claude/skills/suggest-skills/catalog.md`](.claude/skills/suggest-skills/catalog.md).

## Backups

Everything is in this folder, and git keeps a full history of every change,
but only on your Mac until you push it somewhere. If the laptop dies, so do
your notes (Time Machine helps, if you use it). A **backup remote** is a
second copy of the git repository on a server. After each session the
assistant commits and pushes to it. It's called `backup`, and it is the only
remote the assistant will ever push to.

Setup offers three options. Choose based on what's in your notes and what
your employer allows.

### 1. Local only
Nothing leaves your Mac (except what Claude reads while working; see
**Privacy**). Simplest and most private; no protection against losing the
laptop beyond your own Mac backups. You can add a backup later by asking.

### 2. A private GitHub repository
Easy, free, works from anywhere, and you can read your notes from
github.com on any device. Setup creates the repo for you with GitHub's `gh`
tool (or you create it on github.com and paste the URL).

What it means:
- **Your notes live on GitHub's servers.** "Private" means only you, and
  anyone you invite, can see it; it is not end-to-end encrypted. GitHub
  (Microsoft) operates the servers and can be compelled to hand over data;
  read GitHub's terms and privacy settings if that matters to you.
- **Your employer may not allow it.** Many organizations forbid storing work
  information (client details, internal plans, anything regulated) in
  personal cloud accounts. Check before you choose this. If in doubt, track
  only what you'd be comfortable having in a personal account, or use option 3.
- **Personal account vs. your organization's GitHub.** A repo under your
  employer's GitHub organization can be seen by its admins and stays with
  them when you leave. A repo under your personal account is yours.
- **Never make it public.** Switching a repo to public exposes its entire
  history, including things you deleted later. Never create your copy with
  **Fork** from a public repo (forks of public repos are public).
- **Protect the account.** Turn on two-factor authentication; your GitHub
  password now guards your notes.
- **Git never forgets.** Deleting a line from a file doesn't remove it from
  history or from the backup. That's the main reason for the confidentiality
  rule below: keep sensitive details out of the files in the first place.

### 3. Your organization's server
Many universities and companies run their own git hosting (an internal
GitLab or GitHub Enterprise, or a plain server you can reach over SSH). Your
notes stay inside the organization, under its policies, which is usually
what IT wants for work information. The catch: it may only work on the
office network or VPN (the assistant just commits locally when it can't
reach the server, and pushes next time), and the organization's admins can
typically access it. Ask IT for a repository URL, or for SSH access to a
server where you can keep a bare repository; setup takes it from there.

You can switch later: ask the assistant to change the backup, and it will
replace the `backup` remote and push the full history to the new place.

## Privacy and confidentiality

- **What Claude sees.** When the assistant works, Claude reads the files it
  needs, and that text is sent to Anthropic to be processed, like anything
  else you type to Claude. If your employer has an AI policy, it applies
  here.
- **Confidential people.** At setup you name the kinds of people whose
  details are protected in your work: students (FERPA), patients (HIPAA),
  clients under NDA, job candidates, employees' HR matters. The assistant
  never writes their names or details into any file; it uses labels like
  "Client B: contract question (email 2026-10-30)". You keep the mapping
  yourself, somewhere else.
- **You send your own messages.** By default it prepares talking points and
  opens a blank email; it never sends anything and never claims something
  was sent. (You can ask for full drafts in your voice instead.)
- **No accounts.** It doesn't read your mail or calendar. If you want it to
  know something, tell it.

## Updates

New skills and fixes land in this starter from time to time. In your
assistant, say "update the assistant": it fetches only the shared parts
(`.claude/assistant-rules.md`, the built-in skills, `examples/`), shows you
what changed, and never touches your own files or skills.

## What's in the folder

| File | What it holds |
|---|---|
| `CLAUDE.md` | Who you are, what's confidential, your options. Setup writes it; edit it anytime. |
| `now.md` | Active to-dos, kept under 40 lines. |
| `events.md` | Appointments. |
| `inbox.md` | Quick notes not yet sorted. |
| `recurring.md` | Your yearly calendar and standing obligations. |
| `people.md` | Colleagues and contacts, for messages. |
| `ideas.md` | Someday ideas, kept out of the brief. |
| `voice.md` | How you write. |
| `briefs/` | One brief per weekday, plus Friday reviews. |
| `archive/` | Finished items, by month. |
| `.claude/` | The rules and skills. Your own skills go here too. |
| `examples/` | A complete example skill to learn from or copy. |

It's all plain text. Open any file in a text editor and change it; the
assistant reads what's there.

## Tips

- **Capture early, sort later.** A rough line in `inbox.md` beats a
  forgotten email.
- **Start a new session for each sitting.** The assistant remembers through
  the files, not the chat, so a fresh session loses nothing.
- **Let the Friday review prune.** If `now.md` keeps growing, that's a
  signal: something should be dropped, delegated or turned into a skill.
- **Correct it.** "That's not due till the 20th" or "always copy my manager
  on vendor emails": it updates the files, and the next session knows.
