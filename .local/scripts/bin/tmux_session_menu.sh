#! /usr/bin/env bash

source ~/.local/scripts/bin/tmux_util.sh || exit

sessions=$(get_sessions | awk -F: '{print $1}' | sort --unique)
session_count=$(echo "$sessions" | wc -l)
client_height=$(tmux display -p '#{client_height}')
if (( session_count >= ( client_height - 3 ) )); then
  tmux_alert "Not enough space!"
  exit 0
fi

# wth man? what is all that '\'' bs?
session_names=$(echo "$sessions" | awk '{printf "\"%-20s\" \"\" \"run-shell '\''~/.local/scripts/bin/tmux_session_menu_choose.sh %s'\''\" ", $1, $1}')
[ -z "$session_names" ] && return

eval "tmux display-menu -x 0 -y S -M -O ${session_names}"
