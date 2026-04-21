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

echo "Install nvim config..."
stow --target "$HOME/.config" -R nvim

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
sudo apt-get install -y curl wget vim postgresql-common libpq-dev silversearcher-ag ack-grep shellcheck zsh jq tree cmake fzf ssh bat ssh xclip

# X stuff
if xset q &>/dev/null; then
    echo "GUI specific stuff..."

    echo "Add PPAs..."
    # Doing them together saves multiple apt-get update calls
    sudo add-apt-repository ppa:aslatter/ppa -y # alacritty

    echo "Install apt packages..."
    sudo apt-get update
    sudo apt-get install -y alacritty gnome-shell-extension-manager flatpak pavucontrol

    echo "Setup flatpak..."
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

    echo "Install flatpak packages..."
    flatpak install flathub re.sonny.Junction

    echo "Install snap packages..."
    sudo snap install vlc
    # flameshot - not working

    echo "Install gnome extensions..."
    #./helpers/gnome-shell-extension-installer bluetooth-quick-connect@bjarosze.gmail.com
    #./helpers/gnome-shell-extension-installer dash-to-panel@jderose9.github.com
    #./helpers/gnome-shell-extension-installer sound-output-device-chooser@kgshank.net
    #./helpers/gnome-shell-extension-installer caffeine@patapon.info
    #./helpers/gnome-shell-extension-installer mediacontrols@cliffniff.github.com
    #./helpers/gnome-shell-extension-installer tophat@fflewddur.github.io
fi

echo "Install uv"
curl -LsSf https://astral.sh/uv/install.sh | sh

echo "Install antigen for zsh"
curl -L https://raw.githubusercontent.com/zsh-users/antigen/master/bin/antigen.zsh > "$SOURCE/zsh/.zsh/antigen.zsh"

echo "Install vim-plug"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo "Install vim plugins..."
vim +PlugUpdate +qall

echo "Install pip packages with pipx..."
PPKGS="pgcli glances tftui"
for p in $PPKGS
do
    uv tool install "$p"
done

echo "Install Aqua to $HOME/.local/bin..."
curl -sSfL https://raw.githubusercontent.com/aquaproj/aqua-installer/v3.1.2/aqua-installer | bash

echo "Install misc binaries with aqua..."
"$HOME/.local/bin/aqua" i

echo "Install Firefox userChrome..."
PROFILEINI="${HOME}/.mozilla/firefox/profiles.ini"
if [[ -f "$PROFILEINI" ]]; then
    PROFILEDIR=$(awk -F'=' '/^\[Install.*/{ f=1; next }; /^\[.*/{f = 0; next }; f && $1=="Default"{ print $2 }' "$PROFILEINI")
    PROFILEDIR="${HOME}/.mozilla/firefox/${PROFILEDIR}"
    #PROFILEDIR="${HOME}/snap/firefox/common/.mozilla/firefox/${PROFILEDIR}"

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
