#! /usr/bin/env bash

window=$(tmux list-windows -F '#{window_id}&&&#{window_name}' | awk -F'&&&' '$2 ~ /todo/ {print $1}') || exit
current_window=$(tmux list-windows -F '#{window_active}&&&#{window_id}' | awk -F'&&&' '$1 == "1" {print $2}') || exit

if [ -z "$window" ]; then
  tmux display-message "No todo window found in current session."
  exit 0
fi

if [ "$window" = "$current_window" ]; then
  tmux select-window -l
  exit 0
fi

tmux select-window -t "$window"
