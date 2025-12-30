#! /usr/bin/env bash

source ~/.local/scripts/bin/tmux_util.sh || exit

sessions=$(tmux list-sessions -F '#{session_name}' -f '#{!=:#{session_name},quake}')
name=$(tmux_fzf "Kill session" "$sessions") || exit
[ -z "$name" ] && exit 0

output=$(tmux kill-session -t "$name" 2>&1)
if [ "$?" -ne 0 ]; then
  tmux_alert "$output"
  exit
fi

tmux_alert "Session killed."
