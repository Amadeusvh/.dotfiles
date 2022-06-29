#!/usr/bin/env bash

# Terminate already running bar instances
killall -q waybar
killall -q .waybar-wrapped

# Wait until the processes have been shut down
while pgrep -x waybar >/dev/null; do sleep 1; done

# Launch main
waybar

