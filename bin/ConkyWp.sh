#!/bin/sh
#
# pgrep conky &>/dev/null; [ $? = 0 ] && killall conky
#
conky -p2 -d -c "$HOME/conky/pmwconky10rc" &

exit 0
