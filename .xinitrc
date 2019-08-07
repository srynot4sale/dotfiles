#!/usr/bin/env bash

xrdb -merge ~/.Xresources &
xmodmap ~/.Xmodmap

/usr/bin/xscreensaver -no-splash &

eval $(gnome-keyring-daemon)
export SSH_AUTH_SOCK
export GPG_AGENT_INFO
export GNOME-KEYRING-SOCKET
export GNOME-KEYRING-PID
