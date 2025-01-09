#!/usr/bin/env bash

sudo apt update && sudo apt upgrade -y

sudo apt install build-essential vim-gtk3 mc tree tmux htop exuberant-ctags \
    curl git rlwrap zsh unzip gettext autoconf automake cmake make g++ \
    libncurses5-dev libtool libtool-bin libunibilium-dev libunibilium4 \
    ninja-build pkg-config python3-pip python3-dev python3-venv \
    software-properties-common libssl-dev libghc-zlib-dev libcurl4-gnutls-dev \
    libexpat1-dev xsel indent

# latex full
sudo apt install texlive-full

# embedded linux
sudo apt install qemu-system

sudo apt autoremove

# install rust programming language
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
