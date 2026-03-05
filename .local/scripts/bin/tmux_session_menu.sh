#! /usr/bin/env bash

source ~/.local/scripts/bin/tmux_util.sh || exit

session_count=$(tmux list-sessions | wc -l)
client_height=$(tmux display -p '#{client_height}')
if (( session_count >= ( client_height - 3 ) )); then
  tmux_alert "Not enough space!"
  exit 0
fi

session_names=$(tmux list-sessions -F '#{session_name}' | sort --unique | awk '{printf "\"%-20s\" \"\" \"switch-client -t %s\" ", $1, $1}')
[ -z "$session_names" ] && return

eval "tmux display-menu -x 0 -y S -M -O $session_names"
