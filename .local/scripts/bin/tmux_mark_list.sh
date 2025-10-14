#! /usr/bin/env bash

source ~/.local/scripts/bin/tmux_util.sh

STATE="$HOME/.local/share/tmux_marks"
if [ ! -s "$STATE" ]; then
  tmux_alert No marks set
  exit 0
fi

items=$(cat "$STATE")
selected=$(tmux_fzf_nth "Go to mark" 3 "$items") || exit
[ -z "$selected" ] && exit 0

read -r session window pane _name <<< "$selected"

# reorder marks so the most recent one is the first
sorted=$(sed "/^${selected}.*$/d" < "$STATE") || exit
printf "%s\n%s" "$selected" "$sorted" > "$STATE" || exit

tmux switch-client -t "$session" || exit
tmux select-window -t "$window" || exit
tmux select-pane -t "$pane" || exit
