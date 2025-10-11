#! /usr/bin/env bash

sessions=$(tmux list-sessions -F '#{session_last_attached}@#{session_name}' | sort -r | awk -F@ '{printf "%s@%s\n", $2, $1}') || exit
tmux display-popup -B -s bg=terminal -h 100% -w 100% -EE "echo \"$sessions\" | samurai"
