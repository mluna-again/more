#! /usr/bin/env bash

source ~/.local/scripts/bin/tmux_util.sh || exit

STATE="$HOME/.local/share/tmux_marks"

session=$(tmux display -p "#{session_name}") || exit
window=$(tmux display -p "#{window_name}") || exit
pane_index=$(tmux display -p "#{pane_index}") || exit

selected=$(awk "\$1 == \"$session\" && \$2 == \"$window\" && \$3 == \"$pane_index\" {print NR}" "$STATE") || exit
next=$(( selected - 1 )) || exit

next=$(awk "NR==$next" "$STATE")

if [ -z "$next" ]; then
  next=$(tail -n 1 "$STATE")
fi
if [ -z "$next" ]; then
  tmux_alert "No more sessions"
  exit 0
fi

read -r session window pane name <<< "$next"

switch_to_session_window_and_pane "$session" "$window" "$pane" "$name" || exit 0

mark_pane_if_not_already
