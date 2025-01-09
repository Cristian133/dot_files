#!/usr/bin/env bash

mkdir -p ~/.vim/{backups,colors,swaps,undo}

cp -p ./vim/vimrc ~/.vimrc
cp -p ./vim/hybrid.vim ~/.vim/colors/hybrid.vim
cp -r ./vim/vim-sml/* ~/.vim/
