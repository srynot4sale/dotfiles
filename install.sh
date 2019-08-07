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
ln -s $SOURCE/.gitconfig ~/.gitconfig

echo "Install vim config..."
rm -f ~/.vim
ln -s $SOURCE/.vim ~/.vim

echo "Install i3 config..."
rm -f ~/.i3
ln -s $SOURCE/.i3 ~/.i3

echo "Install ack config..."
rm -f ~/.ackrc
ln -s $SOURCE/.ackrc ~/.ackrc

echo "Install X config..."
rm -f ~/.xinitrc
rm -f ~/.Xmodmap
ln -s $SOURCE/.xinitrc ~/.xinitrc
ln -s $SOURCE/.Xmodmap ~/.Xmodmap

echo "Install fzf..."
rm -rf ~/.fzf
ln -s $SOURCE/fzf ~/.fzf
~/.fzf/install --all

echo "Install powerline fonts..."
powerline-fonts/install.sh

echo "Install/update apt packages..."
sudo apt-get install -y curl wget vim postgresql-common libpq-dev silversearcher-ag python-dev gnome-control-center gnome-online-accounts ack-grep vim-gtk3 shellcheck

echo "Install pip"
rm -f get-pip.py
wget --no-check-certificate https://bootstrap.pypa.io/get-pip.py && sudo python get-pip.py
rm -f get-pip.py

echo "Install vim-plug"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo "Install vim plugins..."
vim +PlugUpdate +qall

echo "Install pip packages..."
sudo -H pip install --upgrade pgcli ipython git-goggles termcolor glances
