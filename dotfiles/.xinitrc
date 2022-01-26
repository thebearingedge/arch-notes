#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -f ~/.Xresources ]; then
  xrdb -merge ~/.Xresources
fi

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    # shellcheck source=/dev/null
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# Resolution for 4k 'Virtual-1' in Parallels
modeline=$(cvt 3840 2160 60 | tail -n +2 | awk '{$1=""; print $0}')
modename=$(echo "$modeline" | awk '{print $1}')
xrandr --newmode "$modeline"
xrandr --addmode 'Virtual-1' "$modename"
xrandr --output 'Virtual-1' --mode "$modename"
# Resolution

exec i3
