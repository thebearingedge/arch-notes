#!/bin/sh

# User account (e.g. me)
# For a regular user account, i'll add "well known directories"
# and sudo privileges w/out password
pacman -S xdg-user-dirs sudo stow
me="<you>"
useradd -m "$me"
passwd "$me"
echo "$me ALL=(ALL) NOPASSWD: ALL" > etc/sudoers.d/"$me"
