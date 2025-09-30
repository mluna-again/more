#! /usr/bin/env bash

while read -r pane; do
  tmux send-keys -t "$pane" C-c
done < <(tmux list-panes -F '#{pane_id}')

true
