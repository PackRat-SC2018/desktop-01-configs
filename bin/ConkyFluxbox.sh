#!/bin/sh
#
pgrep conky &>/dev/null; [ $? = 0 ] && killall conky
pgrep compton &>/dev/null; [ $? = 0 ] && killall compton
pkill -x polybar
#
conky -dc /home/doug/conky/conkyfboxrc &

exit 0;

