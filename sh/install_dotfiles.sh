#!/usr/bin/env bash

cp ./git/gitconfig ~/.gitconfig
cp ./htop/htoprc ~/.htoprc
cp ./nano/nanorc ~/.nanorc
cp ./zsh/alias ~/.alias
cp ./env/exports.sh ~/.exports

mkdir ~/.nano

grep -qxF 'source ~/.alias' ~/.zshrc || echo "source ~/.alias" >> ~/.zshrc
grep -qxF 'source ~/.exports' ~/.zshrc || echo "source ~/.exports" >> ~/.zshrc
