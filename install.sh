#!/bin/bash

apx update
apx upgrade

apx update --aur
apx upgrade --aur

apx install --aur --assume-yes openssh firefox git stow rustup rust-analyzer visual-studio-code-bin ttf-arabeyes-fonts ttf-fira-code crystal shards nodejs npm emacs-nativecomp

apx export --aur --bin git
apx export --aur --bin code
apx export --aur --bin stow
apx export --aur --bin crystal
apx export --aur --bin shards
apx export --aur --bin node
apx export --aur --bin npm
apx export --aur --bin npx
apx export --aur --bin emacs
apx export --aur --bin emacsclient
apx export --aur --bin rust-analyzer

apx export --aur code
apx export --aur emacs

apx run --aur rustup default stable
apx export --aur --bin cargo

cd $HOME
mkdir ./Code
mkdir -p .config/emacs/
mkdir -p .config/systemd/user/

cd ./dotfiles
apx run --aur git remote set-url origin git@github.com:tareifz/dotfiles.git
apx run --aur stow git wallpapers emacs systemd

systemctl enable --user emacs
systemctl start --user emacs

apx run --aur rustup component add rust-src