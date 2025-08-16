#! /usr/bin/env bash

current_pane=$(tmux list-panes -F '#{pane_active} #{pane_id}' | awk '$1 == "1" {print $2}') || exit
pane_count=$(tmux list-panes | wc -l) || exit

if (( pane_count > 1 )); then
  tmux display-message "This command only works on windows with 1 pane."
  exit 0
fi

tmux split-window -h -l "30%" || exit
tmux split-window -v -l "50%" || exit
tmux split-window -v -l "50%" || exit
tmux select-pane -t "$current_pane" || exit
tmux split-window -v -l "25%" || exit
tmux select-pane -t "$current_pane" || exit
