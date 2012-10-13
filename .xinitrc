#!/usr/bin/env bash

xrdb -merge ~/.Xresources &

trayer --edge top --align right --SetDockType true --SetPartialStrut true \
 --expand true --width 5 --transparent true --tint 0x000000 --height 17 --alpha 0 &

/usr/bin/xscreensaver -no-splash &
/usr/lib/gnome-settings-daemon/gnome-settings-daemon &

eval $(gnome-keyring-daemon)
export SSH_AUTH_SOCK
export GPG_AGENT_INFO
export GNOME-KEYRING-SOCKET
export GNOME-KEYRING-PID

exec xmonad
