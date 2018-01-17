#!/bin/bash

set -e

SOURCE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Make Go bin dir..."
mkdir -p ~/.go/bin

echo "Install git submodules..."
git submodule update --init --recursive

echo "Making ~/code dirs"
mkdir -p ~/code/go/bin

echo "Install fish config..."
mkdir -p ~/.config/fish/functions
mkdir -p ~/.config/fish/conf.d

for file in $SOURCE/fish/functions/*
do
    rm -f ~/.config/fish/functions/$(basename $file)
    ln -s $file ~/.config/fish/functions/
done

for file in $SOURCE/fish/conf.d/*
do
    rm -f ~/.config/fish/conf.d/$(basename $file)
    ln -s $file ~/.config/fish/conf.d/
done

echo "Install qtile config..."
rm -f ~/.config/qtile
ln -s $SOURCE/qtile ~/.config/qtile

echo "Install git config..."
rm -f ~/.gitconfig
ln -s $SOURCE/.gitconfig ~/.gitconfig

echo "Install vim config..."
rm -f ~/.vim
ln -s $SOURCE/.vim ~/.vim

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

echo "Install new apt sources..."
echo " - fish PPA"

fish_ppa="fish-shell/release-2"

if ! grep -q "$fish_ppa" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    sudo add-apt-repository -y ppa:${fish_ppa}
    sudo apt-get update
else
    echo "Already installed..."
fi

echo "Install/update apt packages..."
sudo apt-get install -y curl wget fish vim postgresql-common libpq-dev silversearcher-ag python-dev gnome-control-center gnome-online-accounts ack-grep vim-gtk3

echo "Install/update fisherman and fish theme..."
if [ ! -d ~/.local/share/fisherman ]; then
    fish -c "curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs git.io/fisherman" || true
fi

fish -l -c "fisher update"
fish -l -c "fisher install omf/theme-bobthefish"


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
sudo pip install --upgrade pgcli ipython git-goggles termcolor
