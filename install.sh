#!/usr/bin/env bash

# Prerequisite
# neovim 6.1+
#   download nvim.appimage from https://github.com/neovim/neovim/releases/tag/v0.6.1
#   sudo mv nvim.appimage /usr/local/bin/nvim
#   sudo chmod +x /usr/local/bin/nvim
# python2 with pynvim (for auto-install lua packages within nvim)
#   python3 -m pip install --user --upgrade pynvim
#   sudo apt-get install python

# Please pay extra attention to nvim.d/my/keymap.lua, some builtin keymaps are cancelled on purpose.
# Please fork this repo, modify to fit your habit.

# Icons provided by Fonts (Nerd Fonts)
# access https://www.nerdfonts.com/font-downloads
# download and unzip the one you like (I use MPlus Nerd Font)
# mv 'M+ 1mn light Nerd Font Complete Mono.ttf' ~/.local/share/fonts
# fc-cache -fv
# fc-list :mono | awk -F: '{print $2}' | sort -u
# change gnome-terminal profile to use mplus (size = 17, make sure the font looks taller)

ln -s `pwd`/vimrc.lua ~/.config/nvim/init.lua
ln -s `pwd`/nvim.d ~/.config/nvim/lua
ln -s `pwd`/UltiSnips ~/.config/nvim/UltiSnips
