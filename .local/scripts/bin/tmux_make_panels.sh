#! /usr/bin/env bash

source ~/.local/scripts/bin/tmux_util.sh || exit

count=$(tmux_ask "How many?")
[ -z "$count" ] && exit 0

if ! [[ "$count" =~ ^[0-9]+$ ]]; then
  tmux_alert "Invalid number."
  exit 0
fi

for (( i=0; i < count; i++ )); do
  tmux split-window -c '#{pane_current_path}'
  tmux select-layout tiled
done
