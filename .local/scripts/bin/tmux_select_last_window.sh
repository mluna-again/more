#! /usr/bin/env bash

last_win=$(tmux list-windows | tail -1 | awk '{print $1}' | sed 's/://') || exit

tmux select-window -t "$last_win"
