#!/usr/bin/env bash

# fonts paths
# system-wide       /usr/local/fonts
# user-specific     $HOME/.local/share/fonts
# user-specific     $HOME/.fonts (deprecated)

# Check if the FONTS_PATH variables are defined
if [ -z "${FONTS_PATH+x}" ]; then
    echo "Error: The variable FONTS_PATH is not defined. Please define it before running the script."
    exit 1
fi

mkdir -p $FONTS_PATH
cd $FONTS_PATH
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/CascadiaMono.zip \
    -o $FONTS_PATH/CascadiaMono.zip
unzip CascadiaMono.zip
rm CascadiaMono.zip
