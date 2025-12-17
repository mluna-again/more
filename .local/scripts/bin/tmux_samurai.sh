#! /usr/bin/env bash

sessions=$(tmux list-sessions -f '#{!=:#{session_name},quake}' -F '#{session_last_attached}@#{session_name}' | sort -hr | awk -F@ '{printf "%s@%s\n", $2, $1}') || exit
tmux display-popup -B -s bg=terminal -h 100% -w 100% -EE sh -c "echo \"$sessions\" | samurai -layout horizontal >~/.cache/samurai_response"

response=$(cat ~/.cache/samurai_response) || exit
[ -z "$response" ] && exit 0

tmux switch-client -t "$response"
