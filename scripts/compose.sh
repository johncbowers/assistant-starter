#!/bin/sh
# Open a new, blank email addressed to the given people, for the user to write.
# usage: scripts/compose.sh gmail|outlook-web|mac ADDRESS [ADDRESS...]
# gmail / outlook-web open a compose page in the default browser; mac opens a
# mailto: link in the Mac's default mail app. It can only open a compose
# window, never read or send mail.
set -eu
[ $# -ge 2 ] || { echo "usage: $0 gmail|outlook-web|mac ADDRESS [ADDRESS...]" >&2; exit 1; }
app=$1; shift
for a in "$@"; do
  case "$a" in *@*.*) ;; *) echo "not an email address: $a" >&2; exit 1 ;; esac
done
to=$(printf '%s,' "$@"); to=${to%,}
case "$app" in
  gmail)       open "https://mail.google.com/mail/?view=cm&fs=1&to=$to" ;;
  outlook-web) open "https://outlook.office.com/mail/deeplink/compose?to=$to" ;;
  mac)         open "mailto:$to" ;;
  *) echo "unknown mail app: $app (gmail, outlook-web or mac)" >&2; exit 1 ;;
esac
