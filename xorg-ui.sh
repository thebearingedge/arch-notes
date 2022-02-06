#!/bin/sh

# I'll use the X Window System
# Wayland might be workable, but that would be a separate writeup.
# I just haven't done the research yet.

# X.org
pacman -S --noconfirm \
  xorg-server \
  xorg-apps \
  xorg-xinit \
  xclip

# Environment
pacman -S --noconfirm \
  picom \
  i3-gaps \
  rofi \
  alacritty \
  ttf-hack \
  noto-fonts \
  feh

aur polybar
