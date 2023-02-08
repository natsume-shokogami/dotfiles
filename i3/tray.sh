#!/bin/bash

#pkill -f retrovol
#pkill -f blueman-applet
pkill -f picom
#pkill -f mate-power-manager
#pkill -f ibus-daemon

#blueman-applet &
#retrovol -hide &
picom -b &
#mate-power-manager &
#ibus-daemon -xrv &
feh --bg-scale ~/.config/i3/background.jpg
