# #!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

XDG_CONFIG_HOME="$HOME/.config"
export XDG_CONFIG_HOME

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# exec gnome-session
# exec startkde
# exec startxfce4
# ...or the Window Manager of your choice
# exec dbus-launch --exit-with-session spectrwm

exec dbus-launch --exit-with-session i3

# exec ck-launch-session dbus-launch --sh-syntax  --exit-with-session awesome
