#!/bin/sh

# I'll use the X Window System
# Wayland might be workable, but that would be a separate writeup.
# I just haven't done the research yet.

# X.org
pacman -S --noconfirm xorg-server xorg-xinit xorg-xdpyinfo xorg-xrandr

# Environment
pacman -S --noconfirm picom i3-gaps rofi alacritty ttf-hack ttf-overpass feh

git clone https://aur.archlinux.org/polybar.git
(
  cd polybar &&
  makepkg --noconfirm --syncdeps --install --rmdeps --clean
)
rm -rf polybar
