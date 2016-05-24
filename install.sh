#!/bin/bash

set -e

SOURCE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Install git submodules"
git submodule update --init --recursive

echo "Install fish config..."
mkdir -p ~/.config/fish
rm ~/.config/fish/config.fish
rm ~/.config/fish/custom
ln -s $SOURCE/fish/config.fish ~/.config/fish/config.fish
ln -s $SOURCE/fish/custom ~/.config/fish/custom

echo "Install qtile config..."
rm ~/.config/qtile
ln -s $SOURCE/qtile ~/.config/qtile

echo "Install git config..."
rm ~/.gitconfig
ln -s $SOURCE/.gitconfig ~/.gitconfig

echo "Install vim config..."
rm ~/.vim
ln -s $SOURCE/.vim ~/.vim

echo "Install X config..."
rm ~/.xinitrc
rm ~/.Xmodmap
ln -s $SOURCE/.xinitrc ~/.xinitrc
ln -s $SOURCE/.Xmodmap ~/.Xmodmap

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
sudo apt-get install -y fish vim postgresql-common libpq-dev

echo "Install/update fisherman and fish theme..."
if [ ! -d ~/.local/share/fisherman ]; then
    fish -c "curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs git.io/fisherman" || true
fi

fish -l -c "fisher update"
fish -l -c "fisher install omf/theme-bobthefish"

echo "Install vim plugins..."
vim +PluginInstall +qall

echo "Install pip packages..."
sudo pip install --upgrade pgcli