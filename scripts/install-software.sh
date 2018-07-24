#!/usr/bin/env bash

apt install stow -y
apt install curl -y
apt install git -y
apt install emacs25 -y
apt install xfonts-terminus -y
curl https://sh.rustup.rs -sSf | sh
curl -sSL https://dist.crystal-lang.org/apt/setup.sh | sudo bash

sudo apt install crystal -y
sudo apt install libssl-dev -y      # for using OpenSSL
sudo apt install libxml2-dev -y     # for using XML
sudo apt install libyaml-dev -y     # for using YAML
sudo apt install libgmp-dev -y      # for using Big numbers
sudo apt install libreadline-dev -y # for using Readline


#### npm install -g eslint
