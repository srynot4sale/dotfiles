# Installation

sudo apt install git
mkdir ~/code
git clone .... code/dotfiles


Run (NOT as root)
    ./install.sh

to complete installation


# Update shell

   chsh


# Turn capslock into another escape

# Gnome extensions

Bluetooth Quick Connect - bjarosze
Sound Output Device Chooser - kgshank
Dash to Panel - jderose9
TopHat - fflewddur


# Gnome settings

```
# Detach modals from their parent window's location
gsettings set org.gnome.mutter attach-modal-dialogs false
```

```
# Map <Super>1 to workspace 1
for i in {1..9}; do gsettings set "org.gnome.desktop.wm.keybindings" "switch-to-workspace-$i" "['<Super>$i']" ; done
```
