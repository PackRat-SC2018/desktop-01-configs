#!/usr/bin/env bash

function run {
  if ! pgrep $1 ;
  then
    $@&
  fi
}

# kill apps from other wm's
pgrep sxhkd &>/dev/null; [ $? = 0 ] && killall sxhkd &
pgrep conky &>/dev/null; [ $? = 0 ] && killall conky &
pgrep compton &>/dev/null; [ $? = 0 ] && killall compton &
# pgrep juiced &>/dev/null; [ $? = 0 ] && killall juiced &
pgrep polybar &>/dev/null; [ $? = 0 ] && killall polybar &
pgrep slstatus &>/dev/null; [ $? = 0 ] && killall i3status &

# standard environment
xmodmap "$HOME/.Xmodmap" &
xrdb -l "$HOME/.Xresources" &
xsetroot -solid "#2B2F72" &

numlockx on

# battery monitor
# juiced -d

# polybar
# Terminate already running bar instances
# pkill -x polybar &

# Wait until the processes have been shut down
#cwhile pgrep -x polybar >/dev/null; do sleep 1; done

# (sleep 2s && polybar awesome-bar) &

nitrogen --restore &

# (sleep 2s && tint2) &
