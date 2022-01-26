#!/usr/bin/env bash

# shellcheck source=/dev/null
[[ -f ~/.bashrc ]] && source ~/.bashrc

if [[ -z "$DISPLAY" ]] && [[ "$(tty)" = /dev/tty1 ]]; then
  startx
  exit
fi
