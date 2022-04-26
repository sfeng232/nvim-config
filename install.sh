#!/usr/bin/env bash

if nvim --version | head -n1 | grep -vq 0.7; then
  echo "expected nvim 0.7, aborting..."
  exit 1
fi

if pip3 list | grep pynvim | grep -vq pynvim; then
  echo "expected pynvim, aborting..."
  exit 1
fi

if tmux -V | grep -vq 3.2; then
  echo "expected tmux 3.2, aborting..."
  exit 1
fi

if ! which rg > /dev/null; then
  echo "rg not found, aborting..."
  exit 1
fi

if ! which fdfind > /dev/null; then
  echo "fdfind not found, aborting..."
  exit 1
fi

if ! which fzf > /dev/null; then
  echo "fzf not found, aborting..."
  exit 1
fi

rm -rf \
  ~/.config/nvim/init.lua \
  ~/.config/nvim/lua \
  ~/.config/nvim/UltiSnips \
  ~/.tmux.conf \
  ~/.config/kitty/kitty.conf

ln -s `pwd`/vimrc.lua ~/.config/nvim/init.lua
ln -s `pwd`/nvim.d ~/.config/nvim/lua
ln -s `pwd`/UltiSnips ~/.config/nvim/UltiSnips
ln -s `pwd`/tmux.conf ~/.tmux.conf
[ -d ~/.config/kitty ] && ln -s `pwd`/kitty.conf ~/.config/kitty/kitty.conf

echo "Symlinks done"

if ! which open-project 1>/dev/null 2>&1; then
  sourceLine="export PATH=\"\$PATH:`pwd`/bin\""
  [ -f ~/.bashrc ] && echo $sourceLine >> ~/.bashrc
  [ -f ~/.zshrc ] && echo $sourceLine >> ~/.zshrc
  echo "RC files Done"
fi

tmux source-file ~/.tmux.conf
echo "Reload tmux done"
