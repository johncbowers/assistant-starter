#!/bin/sh
# Build scripts/apple/AssistantSync.app (git-ignored) from sync.swift.
# Rebuilding may make macOS ask for Calendar/Reminders access again.
set -eu
cd "$(dirname "$0")"
app=AssistantSync.app
rm -rf "$app" && mkdir -p "$app/Contents/MacOS"
cat > "$app/Contents/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
<key>CFBundleIdentifier</key><string>local.assistant.sync</string>
<key>CFBundleName</key><string>Assistant Sync</string>
<key>CFBundleExecutable</key><string>AssistantSync</string>
<key>CFBundlePackageType</key><string>APPL</string>
<key>LSUIElement</key><true/>
<key>NSCalendarsFullAccessUsageDescription</key><string>The executive assistant keeps its own Assistant calendar and reads your calendars for the morning brief.</string>
<key>NSRemindersFullAccessUsageDescription</key><string>The executive assistant syncs your tasks to Reminders and reads the shared list people add to.</string>
</dict></plist>
PLIST
swiftc -O sync.swift -o "$app/Contents/MacOS/AssistantSync"
codesign -s - --force "$app"
echo "built $(pwd)/$app"
