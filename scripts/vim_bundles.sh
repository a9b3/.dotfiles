#!/bin/sh

# https://github.com/Valloric/YouCompleteMe

cd ~/.dotfiles/vim/bundle
rm -RF ~/.dotfiles/vim/bundle/YouCompleteMe
git clone https://github.com/Valloric/YouCompleteMe
cd ~/.dotfiles/vim/bundle/YouCompleteMe/
git submodule update --init --recursive
./install.py --clang-completer --tern-completer
echo ALL DONE
