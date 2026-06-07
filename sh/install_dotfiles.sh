#!/usr/bin/env bash

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cp "$DOTFILES_DIR/git/gitconfig"   ~/.gitconfig
cp "$DOTFILES_DIR/nano/nanorc"     ~/.nanorc
cp "$DOTFILES_DIR/zsh/zshrc"       ~/.zshrc
cp "$DOTFILES_DIR/zsh/alias.sh"    ~/.alias.sh
cp "$DOTFILES_DIR/tmux/tmux.conf"  ~/.tmux.conf
cp "$DOTFILES_DIR/htop/htoprc"     ~/.config/htop/htoprc

mkdir -p ~/.nano ~/.cache/zsh
