#!/usr/bin/env bash

#Build and install neovim for Debian
#See: https://neovim.io/
#See: https://github.com/neovim/neovim/wiki/Building-Neovim#quick-start

#See: https://gist.github.com/darcyparker/153124662b05c679c417

# Check if the DEV variables are defined
if [ -z "${DEV+x}" ]; then
    echo "Error: The variable DEV is not defined. Please define it before running the script."
    exit 1
fi

#Save current dir
pushd . > /dev/null || exit

# Dependencies are installed by the install_so.sh script
sudo apt update && sudo apt upgrade -y

# Enable use of python plugins
# Note: python neovim module was renamed to pynvim
# https://github.com/neovim/neovim/wiki/Following-HEAD#steps-to-update-pynvim-formerly-neovim-python-package
# pip3 uninstall pynvim neovim
pip3 install setuptools --break-system-packages
pip3 install --upgrade pynvim --break-system-packages

npm install -g neovim

# Enable use of ruby plugins
# sudo gem install neovim

#Get or update neovim github repo
mkdir -p ~/$DEV
cd ~/$DEV || exit
if [ ! -e ~/$DEV/neovim ]; then
  git clone https://github.com/neovim/neovim
else
  cd neovim || exit
  git pull origin
fi

cd ~/$DEV/neovim || exit
git checkout master

#Remove old build dir and .deps dir
rm -rf build/
rm -rf .deps/
make distclean

# Build and install neovim
make CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=/usr/local/"
sudo make install

#Restore dir
popd > /dev/null || exit

echo "nvim command: $(command -v nvim)"
echo "nvim command: $(ls -al "$(command -v nvim)")"

cp -r ../nvim ~/.config/
