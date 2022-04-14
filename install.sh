#!/usr/bin/env bash

# Prerequisite
# neovim 6.1+
#   download nvim.appimage from https://github.com/neovim/neovim/releases/tag/v0.6.1
#   sudo mv nvim.appimage /usr/local/bin/nvim
#   sudo chmod +x /usr/local/bin/nvim
# python2 with pynvim (for auto-install lua packages within nvim)
#   python3 -m pip install --user --upgrade pynvim
#   sudo apt-get install python

ln -s `pwd`/vimrc.lua ~/.config/nvim/init.lua
ln -s `pwd`/nvim.d ~/.config/nvim/lua
ln -s `pwd`/UltiSnips ~/.config/nvim/UltiSnips
