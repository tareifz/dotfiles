#!/bin/bash

apx update
apx upgrade

apx update --aur
apx upgrade --aur

apx install --aur --assume-yes openssh firefox git stow rustup visual-studio-code-bin ttf-arabeyes-fonts

apx export --aur --bin git
apx export --aur --bin code
apx export --aur --bin stow

apx export --aur code

apx run --aur rustup default stable
apx export --aur --bin cargo

cd $HOME
mkdir ./Code

cd ./dotfiles
apx run --aur git remote set-url origin git@github.com:tareifz/dotfiles.git
apx run --aur stow git wallpapers
