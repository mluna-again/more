#! /usr/bin/env bash

source ~/.local/scripts/bin/tmux_util.sh || exit

current_name=$(tmux display -p -F "#{session_name}")
name=$(tmux_ask "Rename session" "$current_name") || exit
[ -z "$name" ] && exit 0

if tmux has-session -t "$name"; then
  tmux_alert Duplicate session
  exit 0
fi
tmux rename-session -t . "$name"
