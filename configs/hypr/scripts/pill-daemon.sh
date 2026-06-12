#!/bin/sh
exec 9>"${XDG_RUNTIME_DIR:-/tmp}/pill-watchdog.lock"
flock -n 9 || exit 0

while true; do
    pgrep -f "qs -c pill -d" >/dev/null || qs -c pill -d 2>/dev/null
    sleep 5
done
