#! /usr/bin/env bash

source ~/.local/scripts/bin/tmux_util.sh || exit

while read -r id cmd; do
  looks_empty "$cmd" || continue
  tmux send-keys -t "$id" fish Space -P Enter
  tmux send-keys -t "$id" C-l
done < <(tmux list-panes -F '#{pane_id} #{pane_current_command}')
