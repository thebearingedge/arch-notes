#!/bin/sh

# I'll use the X Window System
# Wayland might be workable, but that would be a separate writeup.
# I just haven't done the research yet.

# X.org
pacman -S --noconfirm \
  xorg-server \
  xorg-xinit \
  xorg-xdpyinfo \
  xorg-xrandr \
  xorg-xprop \
  xorg-xset

# Environment
pacman -S --noconfirm picom i3-gaps rofi alacritty ttf-hack ttf-overpass feh

aur polybar
