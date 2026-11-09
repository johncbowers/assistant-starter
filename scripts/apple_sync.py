#!/usr/bin/env python3
"""Sync the assistant's files with Apple Calendar and Reminders.

usage: apple_sync.py sync              two-way sync (see below), prints a summary
       apple_sync.py agenda FROM [TO]  events on all calendars, for the brief

sync:
  1. Reminders list `list` (the user's tasks): a reminder ticked off on the
     phone marks its now.md line done. Then every open now.md task becomes a
     reminder there (due date at 9:00 with an alert); done or removed ones are
     completed or removed. Only this list is ever rewritten.
  2. Shared list `shared_list` (optional; people who add to the user's plate): new items
     are added to now.md marked `(<shared_label>)`; when the user finishes one
     it is ticked off on the shared list; one ticked off there is marked done
     here. Changed due dates are copied over. Items deleted there are only
     reported (DELETED), never removed here. The link between the two lives in
     sync/shared-list.json.
  3. Calendar `calendar`: events.md lines become events. Only that calendar
     is ever changed.
agenda: reads every calendar on this Mac, except those in `skip`; calendars
  in `anonymize` show only "Appointment (<calendar>)".
Settings: sync/config.json. The helper app is scripts/apple/AssistantSync.app
(build with scripts/apple/build.sh).
"""
import datetime as dt
import hashlib
import json
import re
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
APP = ROOT / "scripts/apple/AssistantSync.app"
CONFIG = json.loads((ROOT / "sync/config.json").read_text())
LINK = ROOT / "sync/shared-list.json"
NOW = ROOT / "now.md"
TODAY = dt.date.today()
TASK = re.compile(r"^- \[( |x)\] (.*?)(?: — (?:due (\d{4}-\d\d-\d\d)|no due date))?(?: \(added [^)]*\))?(?: — done .*)?$")


def helper(command, payload):
    with tempfile.TemporaryDirectory() as tmp:
        src, out = Path(tmp, "in.json"), Path(tmp, "out.json")
        src.write_text(json.dumps(payload))
        for _ in range(3):  # `open -W` now and then fails to wait; just retry
            subprocess.run(["open", "-W", "-g", "-n", str(APP), "--args", command, str(src), str(out)],
                           timeout=120, capture_output=True)
            if out.exists():
                break
        else:
            sys.exit(f"AssistantSync: no answer to {command} (is the app built? scripts/apple/build.sh)")
        result = json.loads(out.read_text())
    if isinstance(result, dict) and "error" in result:
        sys.exit(f"AssistantSync: {result['error']}")
    return result


def key(*parts):
    return hashlib.sha1("|".join(parts).encode()).hexdigest()[:12]


def tasks(lines):
    """(index, done, title, due) for each task line in now.md."""
    out = []
    for i, line in enumerate(lines):
        m = TASK.match(line)
        if m:
            out.append((i, m.group(1) == "x", m.group(2).strip(), m.group(3) or ""))
    return out


def insert(lines, heading, line):
    """Add line at the end of the `## heading` section of now.md."""
    start = lines.index(f"## {heading}")
    end = next((j for j in range(start + 1, len(lines)) if lines[j].startswith("## ")), len(lines))
    while end > start + 1 and not lines[end - 1].strip():
        end -= 1
    lines.insert(end, line)


def section_for(due):
    if not due:
        return "Unsorted"
    return "Due this week" if dt.date.fromisoformat(due) <= TODAY + dt.timedelta(days=7) else "Coming up"


def mark_done(lines, i, on, why=""):
    lines[i] = f"{lines[i].rstrip()} — done {on}{why}"
    lines[i] = lines[i].replace("- [ ]", "- [x]", 1)


def sync_reminders(report):
    own, shared = CONFIG["list"], CONFIG.get("shared_list") or ""
    tag = f" ({CONFIG.get('shared_label') or 'from ' + shared})" if shared else None
    state = helper("reminders", {"lists": [own, shared] if shared else [own]})["reminders"]
    lines = NOW.read_text().split("\n")
    link = json.loads(LINK.read_text()) if LINK.exists() else {}

    # 1. Ticked off on the phone -> done in now.md.
    done_own = {r["key"]: r for r in state if r["list"] == own and r["completed"] and r["key"]}
    for i, done, title, due in tasks(lines):
        if not done and key(title) in done_own:
            mark_done(lines, i, done_own[key(title)]["completedOn"] or TODAY.isoformat())
            report.append(f"done (ticked off in Reminders): {title}")

    # 2. Shared list.
    theirs = {r["id"]: r for r in state if shared and r["list"] == shared}
    complete = []
    for rid, r in theirs.items():
        if rid in link or r["completed"]:
            continue
        title = r["title"].strip()
        if r["notes"].strip():
            title += f" ({r['notes'].strip()})"
        due = r["due"]
        tail = f"due {due}" if due else "no due date"
        insert(lines, section_for(due), f"- [ ] {title}{tag} — {tail} (added {TODAY.isoformat()})")
        link[rid] = title
        report.append(f"new from {shared}: {title}" + (f", due {due}" if due else ""))
    for rid, title in list(link.items()):
        match = [t for t in tasks(lines) if t[2] == f"{title}{tag}"]
        r = theirs.get(rid)
        if not match:
            if r and not r["completed"]:
                report.append(f"LINK LOST: {title} (no matching now.md line; was it reworded?)")
            continue
        i, done, _, due = match[0]
        if r is None:
            if not done:
                report.append(f"DELETED on {shared}: {title} (still open here; ask the user)")
            del link[rid]
            continue
        if done and not r["completed"]:
            complete.append(rid)
            report.append(f"ticked off on {shared}: {title}")
        elif r["completed"] and not done:
            mark_done(lines, i, r["completedOn"] or TODAY.isoformat(), f" (ticked off on {shared})")
            report.append(f"done (ticked off on {shared}): {title}")
        elif not done and r["due"] != due:
            new = f"due {r['due']}" if r["due"] else "no due date"
            lines[i] = re.sub(r" — (due \d{4}-\d\d-\d\d|no due date)", f" — {new}", lines[i], count=1)
            report.append(f"due date changed on {shared}: {title} -> {r['due'] or 'none'}")
        if r["completed"] and done:
            del link[rid]

    NOW.write_text("\n".join(lines))
    LINK.write_text(json.dumps(link, indent=2, ensure_ascii=False) + "\n")

    # 3. Open tasks -> own list (shared items already show on the shared list).
    items, ids_by_key = [], {r["key"]: r["id"] for r in state if r["list"] == own and r["key"]}
    for _, done, title, due in tasks(lines):
        if tag and title.endswith(tag):
            continue
        if done:
            if key(title) in ids_by_key and key(title) not in done_own:
                complete.append(ids_by_key[key(title)])
            continue
        items.append({"key": key(title), "title": title, "due": due})
    # Completed reminders are never deleted, so finished tasks stay ticked off.
    res = helper("apply-reminders", {"list": own, "complete": complete, "items": items})
    report.append(f"Reminders ({own}): {res['created']} new, {res['updated']} changed, "
                  f"{res['removed']} removed, {res['completed']} ticked off")


EVENT = re.compile(r"^- (\d{4}-\d\d-\d\d)(?: to (\d{4}-\d\d-\d\d))?(?: (\d\d:\d\d)(?:[–-](\d\d:\d\d))?)? — (.*?)(?: \(added [^)]*\))?\s*$")


def wanted_events():
    events = []
    path = ROOT / "events.md"
    for line in path.read_text().splitlines() if path.exists() else []:
        m = EVENT.match(line)
        if not m:
            continue
        d1, d2, t1, t2, rest = m.groups()
        title, _, location = rest.partition(" — ")
        start = f"{d1}T{t1}" if t1 else d1
        if t1 and not t2:  # no end time given: one hour
            t2 = (dt.datetime.strptime(t1, "%H:%M") + dt.timedelta(hours=1)).strftime("%H:%M")
        end = f"{d1}T{t2}" if t2 else (d2 or d1)
        # Two events on one day can share a title, so timed events also key on start.
        events.append({"key": key(d1, t1, title) if t1 else key(d1, title), "title": title, "start": start, "end": end,
                       "location": location})
    return events


def sync_calendar(report):
    res = helper("apply-calendar", {"calendar": CONFIG["calendar"], "today": TODAY.isoformat(),
                                    "events": wanted_events()})
    report.append(f"Calendar ({CONFIG['calendar']}): {res['created']} new, {res['updated']} changed, "
                  f"{res['removed']} removed")


def agenda(start, end):
    skip, hide = set(CONFIG.get("skip", [])), set(CONFIG.get("anonymize", []))
    events = helper("read-events", {"from": start, "to": end})
    seen = set()
    for e in sorted(events, key=lambda e: (e["start"], e["title"])):
        if e["calendar"] in skip:
            continue
        title = "Appointment (" + e["calendar"] + ")" if e["calendar"] in hide else e["title"]
        when = e["start"][:10] + (" all day" if e["allDay"] else f" {e['start'][11:]}–{e['end'][11:]}")
        row = (when, title)
        if row in seen:
            continue
        seen.add(row)
        where = f" — {e['location']}" if e["location"] and e["calendar"] not in hide else ""
        print(f"{when} — {title}{where} [{e['calendar']}]")


if __name__ == "__main__":
    if len(sys.argv) >= 2 and sys.argv[1] == "sync":
        report = []
        sync_reminders(report)
        sync_calendar(report)
        print("\n".join(report))
    elif len(sys.argv) >= 3 and sys.argv[1] == "agenda":
        agenda(sys.argv[2], sys.argv[3] if len(sys.argv) > 3 else sys.argv[2])
    else:
        sys.exit(__doc__)
