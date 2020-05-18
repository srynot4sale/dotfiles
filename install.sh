#!/bin/bash

set -e

SOURCE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Install stow..."
sudo apt-get install -y stow

#echo "Make Go bin dir..."
#mkdir -p ~/.go/bin

#echo "Making ~/code dirs"
#mkdir -p ~/code/go/bin

echo "Install git config..."
stow --target "$HOME" -R git

echo "Install zsh config..."
stow --target "$HOME" -R zsh

echo "Install vim config..."
stow --target "$HOME" -R vim

echo "Install alacritty config..."
mkdir -p "$HOME/.config/alacritty"
stow --target "$HOME/.config/alacritty" -R alacritty

echo "Install i3 config..."
stow --target "$HOME" -R i3

echo "Install ack config..."
stow --target "$HOME" -R ack

echo "Install X config..."
stow --target "$HOME" -R x

echo "Install/update apt packages..."
sudo apt-get install -y curl wget vim postgresql-common libpq-dev silversearcher-ag python-dev python3-dev ack-grep shellcheck zsh jq tree cmake

echo "Install fzf"
. /etc/lsb-release
if [[ "$DISTRIB_RELEASE" == "18.04" ]]; then
    echo "Install fzf manually"
    echo "git clone --depth 1 https://github.com/junegunn/fzf.git"
else
    sudo apt-get install -y fzf
fi

# X stuff
if xset q &>/dev/null; then
    sudo apt-get install fonts-powerline fonts-inconsolata

    echo "Install Tela-icon-theme..."
    if [[ -f "$SOURCE/icons/.git/config" ]]; then
        cd "$SOURCE/icons"
        git reset --hard HEAD
        git pull
    else
        git clone https://github.com/vinceliuice/Tela-icon-theme.git "$SOURCE/icons"
        cd "$SOURCE/icons"
    fi

    rm "$SOURCE/icons/links/scalable/apps/Alacritty.svg"
    ln -s "terminal.svg" "$SOURCE/icons/links/scalable/apps/Alacritty.svg"
    ./install.sh ubuntu
    cd "$SOURCE"
fi

echo "Install pip"
rm -f get-pip.py
wget --no-check-certificate https://bootstrap.pypa.io/get-pip.py
sudo python get-pip.py
sudo python3 get-pip.py
rm -f get-pip.py

echo "Install antigen for zsh"
curl -L https://raw.githubusercontent.com/zsh-users/antigen/master/bin/antigen.zsh > "$SOURCE/zsh/.zsh/antigen.zsh"

echo "Install vim-plug"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo "Install vim plugins..."
vim +PlugUpdate +qall

echo "Install pip packages as user..."
pip3 install --upgrade pgcli ipython git-goggles termcolor glances pipenv

echo "Install pip packages as root..."
sudo -H pip3 install --upgrade docker-compose
