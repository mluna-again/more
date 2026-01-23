#! /usr/bin/env bash

current=$(tmux display -p '#{pane_id}') || exit

while read -r pane; do
  tmux select-pane -t "$pane" \; select-layout -E
done < <(tmux list-panes -F '#{pane_id}')

tmux select-pane -t "$current"
