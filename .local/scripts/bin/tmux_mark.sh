#! /usr/bin/env bash

source ~/.local/scripts/bin/tmux_util.sh

STATE="$HOME/.local/share/tmux_marks"

session=$(tmux display -p "#{session_name}") || exit
window=$(tmux display -p "#{window_name}") || exit
pane_index=$(tmux display -p "#{pane_index}") || exit

name=$(tmux_ask "Mark name") || exit
[ -z "$name" ] && exit 0

if [ -n "$(awk "\$4 == \"$name\"" "$STATE")" ]; then
  tmux_alert There is already a mark with that name
  exit 0
fi

printf "%s\n" "$session $window $pane_index $name" >> "$STATE"
