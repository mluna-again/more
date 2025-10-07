#! /usr/bin/env bash

source ~/.local/scripts/bin/tmux_util.sh || exit

current_name=$(tmux display -p -F '#{window_name}')
name=$(tmux_ask "Rename window" "$current_name") || exit
[ -z "$name" ] && exit 0

tmux rename-window -t . "$name"
