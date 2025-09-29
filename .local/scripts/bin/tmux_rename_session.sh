#! /usr/bin/env bash

source ~/.local/scripts/bin/tmux_util.sh || exit

name=$(tmux_ask "Rename session") || exit
[ -z "$name" ] && exit 0

tmux rename-session -t . "$name"
