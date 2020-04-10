#!/bin/sh

#======================================
#
# openbox tint2
#
#======================================

# Terminate already running bar instances
killall -q tint2

# Wait until the processes have been shut down
while pgrep -u $UID -x tint2 >/dev/null; do sleep 1; done

# Launch tint2
# tint2
tint2 -c "$HOME/.config/tint2/tint2lightrc" &

exit 0;