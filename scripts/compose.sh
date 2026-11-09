#!/bin/sh
# Open a new, blank email addressed to the given people, for the user to write.
# usage: scripts/compose.sh ADDRESS [ADDRESS...]
# Uses a mailto: link in the Mac's default mail app: it can only open a
# compose window, never read or send mail.
set -eu
[ $# -ge 1 ] || { echo "usage: $0 ADDRESS [ADDRESS...]" >&2; exit 1; }
for a in "$@"; do
  case "$a" in *@*.*) ;; *) echo "not an email address: $a" >&2; exit 1 ;; esac
done
to=$(printf '%s,' "$@"); to=${to%,}
open "mailto:$to"
