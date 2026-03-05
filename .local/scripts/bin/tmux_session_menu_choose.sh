#! /usr/bin/env bash

source ~/.local/scripts/bin/tmux_util.sh || exit

session="$1"
[ -z "$session" ] && exit

tmux_switch "$session" 1>/dev/null || exit 0
