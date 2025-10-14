#! /usr/bin/env bash

STATE="$HOME/.local/share/tmux_marks"

session=$(tmux display -p "#{session_name}") || exit
window=$(tmux display -p "#{window_name}") || exit
pane_id=$(tmux display -p "#{pane_id}") || exit

selected=$(awk "\$1 == \"$session\" && \$2 == \"$window\" && \$3 == \"$pane_id\" {print NR}" "$STATE") || exit
next=$(( selected + 1 )) || exit

next=$(awk "NR==$next" "$STATE")
if [ -z "$next" ]; then
  next=$(awk "NR==1" "$STATE")
fi

read -r session window pane _name <<< "$next"

tmux switch-client -t "$session" || exit
tmux select-window -t "$window" || exit
tmux select-pane -t "$pane" || exit
