#!/bin/sh

# Add yay for the AUR
# this adds the /usr/bin/yay cli
# https://github.com/Jguer/yay
git clone https://aur.archlinux.org/yay.git
(
  cd yay &&
  makepkg --noconfirm --syncdeps --install --rmdeps --clean
)
rm -rf yay
