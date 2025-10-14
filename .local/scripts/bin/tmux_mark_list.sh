#! /usr/bin/env bash

source ~/.local/scripts/bin/tmux_util.sh || exit

STATE="$HOME/.local/share/tmux_marks"
if [ ! -s "$STATE" ]; then
  tmux_alert No marks set
  exit 0
fi

items=$(cat "$STATE")
selected=$(tmux_fzf_nth "Go to mark" 3 "$items") || exit
[ -z "$selected" ] && exit 0

read -r session window pane name <<< "$selected"

switch_to_session_window_and_pane "$session" "$window" "$pane" "$name" || exit 0

mark_pane_if_not_already
