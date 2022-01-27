#!/bin/sh

# Dev dependencies for building packages
pacman -S --no-confirm git base-devel htop openssh docker docker-compose

sudo usermod -aG docker "$(whoami)"
sudo systemctl enable docker

aur shellcheck-bin
