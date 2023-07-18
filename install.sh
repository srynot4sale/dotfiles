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

echo "Install aqua config..."
stow --target "$HOME" -R aqua

echo "Install dig config..."
stow --target "$HOME" -R dig

echo "Install/update apt packages..."
sudo apt-get update
sudo apt-get install -y curl wget vim postgresql-common libpq-dev silversearcher-ag python3-dev ack-grep shellcheck zsh jq tree cmake python3-pip fzf ssh bat gnome-shell-extension-manager python3.10-venv ssh xclip flatpak

echo "Install snap packages..."
sudo snap install flameshot vlc

echo "Setup flatpak..."
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo "Install flatpak packages..."
flatpak install flathub re.sonny.Junction

echo "Install papirus icon theme..."
sudo add-apt-repository ppa:papirus/papirus
sudo apt-get update && sudo-get apt install papirus-icon-theme

# X stuff
if xset q &>/dev/null; then
    sudo apt-get install fonts-powerline fonts-inconsolata gnome-tweaks

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

echo "Upgrade pip3"
sudo -H python3 -m pip install --upgrade pip

echo "Install antigen for zsh"
curl -L https://raw.githubusercontent.com/zsh-users/antigen/master/bin/antigen.zsh > "$SOURCE/zsh/.zsh/antigen.zsh"

echo "Install vim-plug"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo "Install vim plugins..."
vim +PlugUpdate +qall

echo "Install pip packages as user..."
pip3 install --upgrade pgcli ipython termcolor glances pipenv docker-compose

echo "Install Aqua..."
curl -sSfL https://raw.githubusercontent.com/aquaproj/aqua-installer/v1.1.2/aqua-installer | bash -s -- -i "$HOME/.local/bin/aqua"

echo "Install misc binaries with aqua..."
"$HOME/.local/bin/aqua" i

echo "Install Firefox userChrome..."
PROFILEINI="${HOME}/.mozilla/firefox/profiles.ini"
if [[ -f "$PROFILEINI" ]]; then
    PROFILEDIR=$(awk -F'=' '/^\[Install.*/{ f=1; next }; /^\[.*/{f = 0; next }; f && $1=="Default"{ print $2 }' "$PROFILEINI")
    PROFILEDIR="${HOME}/.mozilla/firefox/${PROFILEDIR}"

    if [[ -d "$PROFILEDIR" ]]; then
        echo "Found profile at ${PROFILEDIR} and stowing config..."
        mkdir -p "${PROFILEDIR}/chrome"
        stow --target "${PROFILEDIR}/chrome" -R mozilla
    fi
fi
