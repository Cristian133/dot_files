#!/usr/bin/env bash

cp .vimrc ~/.vimrc

mkdir -p ~/.vim/{backups,colors,swaps,undo}
cp hybrid.vim ~/.vim/colors/hybrid.vim

mkdir -p ~/.nano/
cp .nanorc ~/.nanorc

cp .gitconfig ~/.gitconfig

cp .alias ~/.alias
# This checks that the line is not in the file to avoid duplicates.
grep -qxF 'source ~/.alias' ~/.zshrc || echo "source ~/.alias" >> ~/.zshrc

cp -r vim-sml/* ~/.vim/
