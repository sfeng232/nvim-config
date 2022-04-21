#!/usr/bin/env bash

rm -rf \
  ~/.config/nvim/init.lua \
  ~/.config/nvim/lua \
  ~/.config/nvim/UltiSnips \
  ~/.tmux.conf

ln -s `pwd`/vimrc.lua ~/.config/nvim/init.lua
ln -s `pwd`/nvim.d ~/.config/nvim/lua
ln -s `pwd`/UltiSnips ~/.config/nvim/UltiSnips
ln -s `pwd`/tmux.conf ~/.tmux.conf

if ! which open-project 1>/dev/null 2>&1; then
  sourceLine="export PATH=\"\$PATH:`pwd`/bin\""
  [ -f ~/.bashrc ] && echo $sourceLine >> ~/.bashrc
  [ -f ~/.zshrc ] && echo $sourceLine >> ~/.zshrc
else
  echo "Done"
fi
