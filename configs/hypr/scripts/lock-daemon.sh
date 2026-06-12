#!/bin/sh
exec 9>"${XDG_RUNTIME_DIR:-/tmp}/lock-watchdog.lock"
flock -n 9 || exit 0

while true; do
    pgrep -f "qs -c lock -d" >/dev/null || qs -c lock -d 2>/dev/null
    sleep 5
done
