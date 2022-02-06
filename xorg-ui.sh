#!/bin/sh

# I'll use the X Window System
# Wayland might be workable, but that would be a separate writeup.
# edit: I have tried Wayland in a Parallels VM (laggy cursor) and on Rpi4 (Manjaro, only 30fps)

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
