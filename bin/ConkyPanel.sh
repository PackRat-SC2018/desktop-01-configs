#!/bin/sh

killall -q compton &

# Terminate already running bar instances
killall -q conky &
killall -q polybar &

# Wait until the processes have been shut down
while pgrep -u $UID -x conky >/dev/null; do sleep 1; done

conky -p6 -dc /home/doug/conky/conkyhorizrc &

exit 0;
