#! /usr/bin/env bash

source ~/.local/scripts/bin/tmux_util.sh || exit

name=$(tmux_ask "Session name:") || exit
[ -z "$name" ] && exit 0

tmux new-session -d -c ~ -s "$name"
tmux switch-client -t "$name" || exit

true
