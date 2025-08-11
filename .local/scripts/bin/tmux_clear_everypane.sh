#! /usr/bin/env bash

while read -r pane; do
  id="$(awk '{print $1}' <<< "$pane")"

  tmux send-keys -t "$id" C-l
done < <(tmux list-panes -F "#{pane_id}")

true
