#!/usr/bin/env bash

# https://github.com/tmux-plugins/tpm

git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm

if [ ! -e "$HOME/.tmux.conf" ]; then
  cp -p ../tmux/.tmux.conf "$HOME/"
else
  echo ".tmux.conf already exists in $HOME, it will not be copied."
fi

# prefix + shift + i
