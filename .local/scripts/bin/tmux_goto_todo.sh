#! /usr/bin/env bash

source ~/.local/scripts/bin/tmux_util.sh || exit

window=$(tmux list-windows -F '#{window_id} #{window_name}' | awk '$2 ~ /todo/ {print $1}') || exit
current_window=$(tmux list-windows -F '#{window_active} #{window_id}' | awk '$1 == "1" {print $2}') || exit
read -r pane pane_cmd < <(tmux list-panes -t todo -F '#{pane_id} #{pane_current_command}' | head -1)

if [ "$window" = "$current_window" ] && [ "$pane_cmd" = emacsclient ]; then
  tmux select-window -l
  exit 0
fi

if [ -z "$window" ]; then
  tmux new-window -n todo -c '#{pane_current_path}'
fi

tmux select-window -t todo

# reeval in case window was just created
read -r pane pane_cmd < <(tmux list-panes -t todo -F '#{pane_id} #{pane_current_command}' | head -1) || exit

pane_count=$(tmux list-panes -t todo | wc -l) || exit
if (( pane_count > 1 )); then
  tmux display "More than one pane open."
  exit 0
fi

if ! looks_empty "$pane_cmd"; then
  if [ "$pane_cmd" != emacsclient ]; then
    tmux display "Another program running."
    exit 0
  fi

  exit 0
fi

tmux send-keys -t "$pane" emacsc Space todo.org Enter

tmux select-window -t "$window"
