#! /usr/bin/env bash

source ~/.local/scripts/bin/tmux_util.sh || exit

session_names=$(tmux list-sessions -F '#{session_name}' | sort --unique | awk '{printf "\"%-20s\" \"\" \"switch-client -t %s\" ", $1, $1}')
[ -z "$session_names" ] && return

eval "tmux display-menu -x 0 -y S -M -O $session_names"
