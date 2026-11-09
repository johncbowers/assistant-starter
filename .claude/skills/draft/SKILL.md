---
name: draft
description: Prepare an email or message for the user to write and send themselves — talking points plus a blank email addressed to the recipient (or a full draft, if CLAUDE.md says the user wants those). Use when the user asks for a draft, an email, or what to say to someone, or accepts an offer of one.
---

# Draft

What goes out under the user's name should be their own thought. So by
default you prepare and they write. Write a full draft only if CLAUDE.md
**Options** says they want them (or they ask for one this time).

## Talking points (default)
1. Check `people.md` for the recipient: name, role, context, email address.
2. List, as short bullets, what the message needs to cover: the ask, the
   facts and dates from the files (absolute dates), anything the recipient
   needs to reply with, and open questions. Facts only, in your words, no
   phrasing for them to copy. Unknown → say so in the bullet. Never invent
   dates, places, names or commitments.
3. Suggest a subject line (they may ignore it).
4. Open a blank email to the recipient: `scripts/compose.sh <mail app>
   <address>`, with the mail app from CLAUDE.md **Options** (`gmail`,
   `outlook-web` or `mac`). It only opens a compose window with the To line
   filled. No address in `people.md` → ask the user, add it there (not for
   confidential people), then open the email. Not email (Slack, Teams,
   text) → just give the bullets.
5. Confidential people (rule 4): details the user gives in this session may
   go in the bullets, but **never into any file**.

## Full draft (only when CLAUDE.md or the user asks)
1. Read `voice.md` and match its greeting, tone and sign-off.
2. Same facts rules as above; unknowns in `[BRACKETS]`.
3. Output a subject line and body, ready to paste. Keep it short.
4. Open a blank email to the recipient as in step 4 above, for them to
   paste into.

## Either way
Don't mark anything as sent. If the message fulfils a tracked item, ask the
user to tell you once it's sent, then update the file.
