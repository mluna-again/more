#! /usr/bin/env bash

source ~/.local/scripts/bin/tmux_util.sh || exit

query=$(tmux_ask "Search down") || exit
[ -z "$query" ] && exit 0

tmux send-keys -X search-forward "$query"
