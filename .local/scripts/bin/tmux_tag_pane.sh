#! /usr/bin/env bash

source ~/.local/scripts/bin/tmux_util.sh || exit

key="$1"
[ -z "$key" ] && exit 1

info=$(tmux display -p '#{session_name}@@@#{window_id}@@@#{pane_id}') || exit
session=$(awk -F@@@ '{print $1}' <<< "$info") || exit
window=$(awk -F@@@ '{print $2}' <<< "$info") || exit
pane=$(awk -F@@@ '{print $3}' <<< "$info") || exit

tmux bind -Troot "$key" switch-client -t "$session" \\\; select-window -t "$window" \\\; select-pane -t "$pane" \; display 'Pane tagged.'
