#!/bin/sh
#
pgrep conky &>/dev/null; [ $? = 0 ] && killall conky
pgrep compton &>/dev/null; [ $? = 0 ] && killall compton
pkill -x polybar
#
conky -p2 -dc /home/doug/conky/conkyclockrc &

exit 0
