#! /usr/bin/env bash

sessions=$(tmux list-sessions -F '#{session_last_attached}@#{session_name}' | sort -r | awk -F@ '{printf "%s@%s\n", $2, $1}') || exit
tmux display-popup -B -s bg=terminal -h 100% -w 100% -EE sh -c "echo \"$sessions\" | samurai >~/.cache/samurai_response"

response=$(cat ~/.cache/samurai_response) || exit
[ -z "$response" ] && exit 0

tmux switch-client -t "$response"
