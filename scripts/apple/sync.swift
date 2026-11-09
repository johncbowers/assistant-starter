// Assistant Sync: the executive assistant's bridge to Calendar and Reminders.
// Runs as its own app bundle (so macOS asks for access once, for this app).
// usage (via scripts/apple_sync.py): AssistantSync <command> <in.json> <out.json>
//   read-events     in: {"from": "YYYY-MM-DD", "to": "YYYY-MM-DD"}
//   reminders       in: {"lists": ["Assistant", "Shared with me"]}
//   apply-calendar  in: {"calendar": "Assistant", "today": "YYYY-MM-DD", "events": [...]}
//   apply-reminders in: {"list": "Assistant", "items": [...], "complete": [ids]}
// Only the calendar and list named in apply-* are ever changed; items are
// matched by their url (assistant://<key>). Everything else is read-only.
import EventKit
import Foundation

let store = EKEventStore()
let args = CommandLine.arguments
let day = DateFormatter()
day.dateFormat = "yyyy-MM-dd"
let stamp = DateFormatter()
stamp.dateFormat = "yyyy-MM-dd'T'HH:mm"

func finish(_ obj: Any) -> Never {
    let data = try! JSONSerialization.data(withJSONObject: obj, options: [.prettyPrinted, .sortedKeys])
    try! data.write(to: URL(fileURLWithPath: args[3]))
    exit(0)
}
func fail(_ msg: String) -> Never { finish(["error": msg]) }

guard args.count == 4 else { fail("usage: AssistantSync <command> <in.json> <out.json>") }
let input = (try? JSONSerialization.jsonObject(with: Data(contentsOf: URL(fileURLWithPath: args[2])))) as? [String: Any] ?? [:]

let sem = DispatchSemaphore(value: 0)
var granted = true
store.requestFullAccessToEvents { ok, _ in granted = granted && ok; sem.signal() }
sem.wait()
store.requestFullAccessToReminders { ok, _ in granted = granted && ok; sem.signal() }
sem.wait()
guard granted else { fail("no access: allow Assistant Sync in System Settings > Privacy & Security > Calendars and Reminders") }

func ownCalendar(_ name: String, _ type: EKEntityType) -> EKCalendar {
    if let c = store.calendars(for: type).first(where: { $0.title == name && $0.allowsContentModifications }) { return c }
    let c = EKCalendar(for: type, eventStore: store)
    c.title = name
    let def = type == .event ? store.defaultCalendarForNewEvents : store.defaultCalendarForNewReminders()
    // Put it in iCloud (so it reaches the phone): the account that already
    // holds calendars/lists of this type there, else the default one.
    c.source = store.calendars(for: type).first { $0.source.title == "iCloud" && $0.allowsContentModifications }?.source
        ?? def?.source
    do { try store.saveCalendar(c, commit: true) } catch { fail("can't create \(name): \(error)") }
    return c
}

func key(_ item: EKCalendarItem) -> String? {
    guard let u = item.url?.absoluteString, u.hasPrefix("assistant://") else { return nil }
    return String(u.dropFirst("assistant://".count))
}

switch args[1] {
case "read-events":
    guard let from = day.date(from: input["from"] as? String ?? ""),
          let to0 = day.date(from: input["to"] as? String ?? "") else { fail("from/to") }
    let to = Calendar.current.date(byAdding: .day, value: 1, to: to0)!
    let pred = store.predicateForEvents(withStart: from, end: to, calendars: nil)
    finish(store.events(matching: pred).map { e in [
        "calendar": e.calendar.title, "source": e.calendar.source.title,
        "title": e.title ?? "", "start": stamp.string(from: e.startDate),
        "end": stamp.string(from: e.endDate), "allDay": e.isAllDay,
        "location": e.location ?? "", "assistant": key(e) != nil] as [String: Any] })

case "reminders":
    let names = input["lists"] as? [String] ?? []
    let lists = store.calendars(for: .reminder).filter { names.contains($0.title) }
    var out: [[String: Any]] = []
    let pred = store.predicateForReminders(in: lists.isEmpty ? [] : lists)
    if !lists.isEmpty {
        store.fetchReminders(matching: pred) { rs in
            for r in rs ?? [] {
                var due = ""
                if let d = r.dueDateComponents, let dd = Calendar.current.date(from: d) { due = day.string(from: dd) }
                out.append(["list": r.calendar.title, "id": r.calendarItemExternalIdentifier ?? r.calendarItemIdentifier,
                            "title": r.title ?? "", "due": due, "notes": r.notes ?? "",
                            "completed": r.isCompleted,
                            "completedOn": r.completionDate.map { day.string(from: $0) } ?? "",
                            "key": key(r) ?? ""])
            }
            sem.signal()
        }
        sem.wait()
    }
    finish(["lists": lists.map { $0.title }, "reminders": out])

case "apply-calendar":
    let cal = ownCalendar(input["calendar"] as? String ?? "Assistant", .event)
    let today = day.date(from: input["today"] as? String ?? "") ?? Date()
    let far = Calendar.current.date(byAdding: .year, value: 3, to: today)!
    let back = Calendar.current.date(byAdding: .day, value: -60, to: today)!
    var existing: [String: EKEvent] = [:]
    for e in store.events(matching: store.predicateForEvents(withStart: back, end: far, calendars: [cal])) {
        if let k = key(e) { existing[k] = e }
    }
    var made = 0, changed = 0, removed = 0
    var wanted = Set<String>()
    for spec in input["events"] as? [[String: Any]] ?? [] {
        guard let k = spec["key"] as? String, let start = spec["start"] as? String else { continue }
        wanted.insert(k)
        let allDay = !start.contains("T")
        let s = allDay ? day.date(from: start)! : stamp.date(from: start)!
        let endS = spec["end"] as? String ?? start
        var e2 = allDay ? day.date(from: endS)! : stamp.date(from: endS)!
        if allDay { e2 = Calendar.current.date(byAdding: .day, value: 1, to: e2)!.addingTimeInterval(-1) }
        let title = spec["title"] as? String ?? ""
        let loc = spec["location"] as? String ?? ""
        let e = existing[k] ?? EKEvent(eventStore: store)
        let fresh = existing[k] == nil
        if fresh || e.title != title || e.startDate != s || e.isAllDay != allDay || (e.location ?? "") != loc
            || (!allDay && e.endDate != e2) {
            e.calendar = cal; e.title = title; e.isAllDay = allDay; e.startDate = s; e.endDate = e2
            e.location = loc.isEmpty ? nil : loc
            e.url = URL(string: "assistant://\(k)")
            do { try store.save(e, span: .thisEvent, commit: false) } catch { fail("save \(title): \(error)") }
            if fresh { made += 1 } else { changed += 1 }
        }
    }
    for (k, e) in existing where !wanted.contains(k) && e.startDate >= Calendar.current.startOfDay(for: today) {
        try? store.remove(e, span: .thisEvent, commit: false); removed += 1
    }
    do { try store.commit() } catch { fail("commit: \(error)") }
    finish(["created": made, "updated": changed, "removed": removed])

case "apply-reminders":
    let list = ownCalendar(input["list"] as? String ?? "Assistant", .reminder)
    let target = input["list"] as? String ?? "Assistant"
    var all: [EKReminder] = []
    store.fetchReminders(matching: store.predicateForReminders(in: store.calendars(for: .reminder))) { rs in all = rs ?? []; sem.signal() }
    sem.wait()
    var made = 0, changed = 0, removed = 0, completed = 0
    // Complete items by id (e.g. on the shared list) when the user finished them.
    let done = Set(input["complete"] as? [String] ?? [])
    for r in all where done.contains(r.calendarItemExternalIdentifier ?? "") && !r.isCompleted {
        r.isCompleted = true; try? store.save(r, commit: false); completed += 1
    }
    // Remove by key: only items this tool made (assistant:// url) in this list.
    let gone = Set(input["remove"] as? [String] ?? [])
    for r in all where r.calendar.calendarIdentifier == list.calendarIdentifier && gone.contains(key(r) ?? "") {
        try? store.remove(r, commit: false); removed += 1
    }
    if let items = input["items"] as? [[String: Any]] {
        var existing: [String: EKReminder] = [:]
        for r in all where r.calendar.calendarIdentifier == list.calendarIdentifier { if let k = key(r) { existing[k] = r } }
        var wanted = Set<String>()
        for spec in items {
            guard let k = spec["key"] as? String else { continue }
            wanted.insert(k)
            let title = spec["title"] as? String ?? ""
            let due = spec["due"] as? String ?? ""
            let r = existing[k] ?? EKReminder(eventStore: store)
            let fresh = existing[k] == nil
            var comps: DateComponents? = nil
            if let d = day.date(from: due) {
                var c = Calendar.current.dateComponents([.year, .month, .day], from: d); c.hour = 9; c.minute = 0
                comps = c
            }
            let oldDue = r.dueDateComponents.flatMap { Calendar.current.date(from: $0) }.map { day.string(from: $0) } ?? ""
            if fresh || r.title != title || oldDue != due {
                r.calendar = list; r.title = title; r.dueDateComponents = comps
                r.alarms?.forEach { r.removeAlarm($0) }
                if let c = comps, let d = Calendar.current.date(from: c) { r.addAlarm(EKAlarm(absoluteDate: d)) }
                r.url = URL(string: "assistant://\(k)")
                do { try store.save(r, commit: false) } catch { fail("save \(title): \(error)") }
                if fresh { made += 1 } else { changed += 1 }
            }
        }
        for (k, r) in existing where !wanted.contains(k) && !r.isCompleted {
            try? store.remove(r, commit: false); removed += 1
        }
    }
    do { try store.commit() } catch { fail("commit: \(error)") }
    finish(["list": target, "created": made, "updated": changed, "removed": removed, "completed": completed])

default:
    fail("unknown command \(args[1])")
}
