#!/bin/sh

# Dev dependencies for building packages
pacman -S --no-confirm git base-devel

git clone https://aur.archlinux.org/shellcheck-bin.git shellcheck
(
  cd shellcheck &&
  makepkg --noconfirm --syncdeps --install --rmdeps --clean
)
rm -rf shellcheck
