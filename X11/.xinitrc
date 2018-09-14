#!/bin/bash

[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources

xsetroot -cursor_name left_ptr
xset -b
feh --bg-fill $(find ~/Pictures/backgrounds -type f | shuf -n 1) --no-fehbg

compton &
sxhkd & exec bspwm
