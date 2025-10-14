#! /usr/bin/env bash

source ~/.local/scripts/bin/tmux_util.sh || exit

STATE="$HOME/.local/share/tmux_marks"
if [ ! -s "$STATE" ]; then
  tmux_alert No marks set
  exit 0
fi

items=$(cat "$STATE")
selected=$(tmux_fzf_nth "Remove mark" 3 "$items") || exit
[ -z "$selected" ] && exit 0

clean=$(sed -e "/^.*${selected}.*$/d" "$STATE" -e '/^\s*$/d') || exit

if [ -n "$clean" ]; then
  echo "$clean" > "$STATE"
else
  : > "$STATE"
fi
