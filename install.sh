#!/bin/bash

set -e

SOURCE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [[ "$USER" == "root" ]];
then
    echo "Do not run as root"
    exit 3
fi

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
sudo apt-get install -y curl wget vim postgresql-common libpq-dev silversearcher-ag python3-dev ack-grep shellcheck zsh jq tree cmake python3-pip fzf ssh bat python3.10-venv ssh xclip

# X stuff
if xset q &>/dev/null; then
    echo "GUI specific stuff..."

    echo "Add PPAs..."
    # Doing them together saves multiple apt-get update calls
    sudo add-apt-repository ppa:papirus/papirus -y
    sudo add-apt-repository ppa:aslatter/ppa -y # alacritty

    echo "Install apt packages..."
    sudo apt-get update
    sudo apt-get install -y papirus-icon-theme alacritty gnome-shell-extension-manager flatpak

    echo "Setup flatpak..."
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

    echo "Install flatpak packages..."
    flatpak install flathub re.sonny.Junction

    echo "Install snap packages..."
    sudo snap install vlc
    # flameshot - not working
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

echo "Install pip packages with pipx..."
PIP_REQUIRE_VIRTUALENV=false python3 -m pip install --user pipx
PPKGS="pgcli ipython glances pipenv autorandr tftui"
for p in $PPKGS
do
    pipx install "$p"
done

echo "Install Aqua to $HOME/.local/bin..."
curl -sSfL https://raw.githubusercontent.com/aquaproj/aqua-installer/v3.0.1/aqua-installer | bash
ln -f -s ~/.local/share/aquaproj-aqua/bin/aqua ~/.local/bin/aqua

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

echo
echo "#######################"
echo "# install.sh complete!"
echo "#######################"
