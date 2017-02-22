#!/bin/bash

set -e

SOURCE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Install git submodules"
git submodule update --init --recursive

echo "Install fish config..."
mkdir -p ~/.config/fish
rm -f ~/.config/fish/config.fish

for file in $SOURCE/fish/functions/*
do
    ln -s $file ~/.config/fish/functions/
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

echo "Install fzf"
rm -rf ~/.fzf
ln -s $SOURCE/fzf ~/.fzf
~/.fzf/install

echo "Install new apt sources..."
echo " - fish PPA"

fish_ppa="fish-shell/release-2"

if ! grep -q "$fish_ppa" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    sudo add-apt-repository ppa:${fish_ppa}
    sudo apt-get update
else
    echo "Already installed..."
fi

echo "Install/update apt packages..."
sudo apt-get install -y fish vim postgresql-common libpq-dev silversearcher-ag python-dev gnome-control-center gnome-online-accounts ack-grep vim-gtk3

echo "Install/update fisherman and fish theme..."
if [ ! -d ~/.local/share/fisherman ]; then
    fish -c "curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs git.io/fisherman" || true
fi

fish -l -c "fisher update"
fish -l -c "fisher install omf/theme-bobthefish"

echo "Install vim plugins..."
vim +PluginInstall +qall

echo "Install YouCompleteMe..."
~/.vim/bundle/YouCompleteMe/install.sh

echo "Install pip packages..."
sudo pip install --upgrade pgcli ipython
