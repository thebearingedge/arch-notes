#!/usr/bin/env bash

[[ $- != *i* ]] && return

if [ -d ~/.bashrc.d ]; then
  for f in ~/.bashrc.d/*; do
    # shellcheck source=/dev/null
    [ -x "$f" ] && source "$f"
  done
  unset f
fi
