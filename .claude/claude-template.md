@.claude/assistant-rules.md

# About this setup

The rules above come from the starter kit and are updated by the
`update-assistant` skill; don't edit `.claude/assistant-rules.md` or the
starter's skills here (changes would be overwritten). This file holds what is
specific to this user; edit it freely.

## About the user

- <Name>, <title>, <team or department>, <organization>.
- Field: <field or industry, in a few words>.
- The job, in their words: <what a typical week involves>.
- Busy seasons and cycles: <e.g. quarterly reports, budget season in March, grant deadlines>.
- <Anything else the user wants the assistant to know about their role.>

## Confidential

Never write names or details of these into any file (rule 4):
- People: <e.g. students (FERPA) | patients (HIPAA) | clients under NDA | job candidates>
- Information that makes anyone confidential: <e.g. HR or performance matters | background checks | health>
Labels to use instead: <e.g. "Client A", "candidate #3">
Never typed here at all (employer policy): <e.g. patient health information | none known>
Claude approved for work by the employer: <yes | not required | unknown — check>

## Options

- Backup remote: <`backup` = <URL> (<GitHub private | organization server>) | none (local only)>
- Messages: <talking points + a blank email (default) | full drafts in the user's voice>
- Mail app: <gmail | outlook-web | mac> (`scripts/compose.sh`)
- Phone inbox: <yes (iPhone "Capture" shortcut) | no>
- Morning brief + Friday review: <scheduled | on request>
- Starter kit: <URL the folder was cloned from>, last updated <YYYY-MM-DD>

## More files

| File | What it holds |
|---|---|

## More procedures

<!-- One line per skill the user added with `suggest-skills`:
- `<name>` — <what it handles> (tracker: `<file>.md`) -->
