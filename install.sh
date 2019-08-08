#!/bin/bash

set -e

SOURCE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Make Go bin dir..."
mkdir -p ~/.go/bin

echo "Install git submodules..."
git submodule update --init --recursive

echo "Making ~/code dirs"
mkdir -p ~/code/go/bin

echo "Install git config..."
rm -f ~/.gitconfig
ln -s "$SOURCE/.gitconfig" ~/.gitconfig

echo "Install zsh config..."
rm -f ~/.zshrc
rm -f ~/.zsh
ln -s "$SOURCE/.zshrc" ~/.zshrc
ln -s "$SOURCE/.zsh" ~/.zsh

echo "Install vim config..."
rm -f ~/.vim
ln -s "$SOURCE/.vim" ~/.vim

echo "Install i3 config..."
rm -f ~/.i3
ln -s "$SOURCE/.i3" ~/.i3

echo "Install ack config..."
rm -f ~/.ackrc
ln -s "$SOURCE/.ackrc" ~/.ackrc

echo "Install X config..."
rm -f ~/.xinitrc
rm -f ~/.Xmodmap
ln -s "$SOURCE/.xinitrc" ~/.xinitrc
ln -s "$SOURCE/.Xmodmap" ~/.Xmodmap

echo "Install/update apt packages..."
sudo apt-get install -y curl wget vim postgresql-common libpq-dev silversearcher-ag python-dev ack-grep vim-gtk3 shellcheck zsh jq fonts-powerline tree

echo "Install fzf"
. /etc/lsb-release
if [[ "$DISTRIB_RELEASE" == "16.04" ]]; then
    rm -rf ~/.fzf
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
else
    sudo apt-get install -y fzf
fi

echo "Install pip"
rm -f get-pip.py
wget --no-check-certificate https://bootstrap.pypa.io/get-pip.py && sudo python get-pip.py
rm -f get-pip.py

echo "Install antigen for zsh"
rm -f ~/.zsh/antigen.zsh
curl -L git.io/antigen > ~/.zsh/antigen.zsh

echo "Install vim-plug"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo "Install vim plugins..."
vim +PlugUpdate +qall

echo "Install pip packages..."
sudo -H pip install --upgrade pip pgcli ipython git-goggles termcolor glances docker-compose
