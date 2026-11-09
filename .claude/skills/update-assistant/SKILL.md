---
name: update-assistant
description: Pull new or changed skills and rules from the starter kit this assistant was set up from, without touching the user's own files. Use when the user asks to update the assistant or get new features/skills.
---

# Update from the starter kit

Only these come from the starter kit; everything else (CLAUDE.md, now.md,
the user's own skills and trackers, …) is the user's and is never touched:
- `.claude/assistant-rules.md`
- `.claude/claude-template.md`
- `.claude/skills/<name>/` for each skill folder that exists in the starter
- `examples/`

1. Find the starter URL in CLAUDE.md **Options** (`Starter kit:`). None →
   ask the user for it.
2. `git status --porcelain`: uncommitted changes → commit them first
   (rule 7).
3. `git fetch <url> main`. This fetches once by URL; **don't add a remote**
   (rule 7). Fails → say so and stop.
4. `git diff --stat HEAD FETCH_HEAD -- .claude/assistant-rules.md
   .claude/claude-template.md .claude/skills examples` and read the full
   diff. Ignore deletions (the user's own skills aren't in the starter).
   Summarize for the user: new skills, changed skills, rule changes, each in
   one line in plain words.
5. If the user changed one of those starter files here themselves (the
   commit history shows edits other than a previous update), say which, and
   ask before overwriting it.
6. On their yes: `git checkout FETCH_HEAD -- <each path that changed>`.
   Skills removed from the starter are left alone; mention them.
7. If `claude-template.md` changed, compare it with CLAUDE.md: a new option
   or section → ask the user for the answer and add it to CLAUDE.md.
8. Set the `last updated` date on the Starter kit line in CLAUDE.md, commit
   (`update: from starter kit`), push to `backup` if there is one. Tell the
   user to start a new session so the new skills and rules load.
