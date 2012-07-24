#!/usr/bin/env bash

xrdb -merge ~/.Xresources &

trayer --edge top --align right --SetDockType true --SetPartialStrut true \
 --expand true --width 5 --transparent false --tint 0xffffff --height 15 &

/usr/bin/xscreensaver -no-splash &
/usr/lib/gnome-settings-daemon/gnome-settings-daemon &

eval $(gnome-keyring-daemon)
export GNOME-KEYRING-SOCKET
export GNOME-KEYRING-PID

exec xmonad
