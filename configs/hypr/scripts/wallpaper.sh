#!/usr/bin/env bash
# Random wallpaper via awww (formerly swww) with a wave transition.
# Usage: wallpaper.sh init   -> start daemon, set initial only if freshly started (reload-safe)
#        wallpaper.sh         -> cycle to a new random wallpaper now (SUPER+B)
set -euo pipefail

WPDIR="$HOME/Ricelin/wallpapers"

daemon_was_running=true
if ! awww query >/dev/null 2>&1; then
    awww-daemon >/dev/null 2>&1 &
    sleep 0.6
    daemon_was_running=false
fi

if [ "${1:-}" = "init" ] && [ "$daemon_was_running" = true ]; then
    exit 0
fi

pic=$(find "$WPDIR" -type f \( -iname '*.jpg' -o -iname '*.png' \) | shuf -n1)
[ -n "$pic" ] || exit 0

awww img "$pic" \
    --transition-type wave \
    --transition-angle 30 \
    --transition-wave "60,30" \
    --transition-fps 60 \
    --transition-step 90
