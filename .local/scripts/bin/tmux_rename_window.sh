#! /usr/bin/env bash

source ~/.local/scripts/bin/tmux_util.sh || exit

name=$(tmux_ask "Rename window") || exit
[ -z "$name" ] && exit 0

tmux rename-window -t . "$name"
