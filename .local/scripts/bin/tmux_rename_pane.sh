#! /usr/bin/env bash

source ~/.local/scripts/bin/tmux_util.sh || exit

current_name=$(tmux display -p -F '#{pane_title}')
name=$(tmux_ask "Rename pane" "$current_name") || exit
[ -z "$name" ] && exit 0

tmux set-option -t . -p allow-set-title off \; select-pane -t . -T "$name"
