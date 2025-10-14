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
[ -z "$next" ] && exit 0

read -r session window pane _name <<< "$next"

tmux switch-client -t "$session" || exit
tmux select-window -t "$window" || exit
tmux select-pane -t "$pane" || exit

mark_pane_if_not_already
