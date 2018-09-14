#!/usr/bin/env bash

# Terminate polybar if running
killall -q polybar

# Wait until the processes have been shutdown
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Lunch bar1 & bar
polybar top &
polybar bottom &

echo "Bars launched..."
