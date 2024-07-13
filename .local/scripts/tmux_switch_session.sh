#! /usr/bin/env bash

output=$(tmux list-windows -a -F "#{session_id} #{window_id} #{session_name}: #{window_name}" | \
	fzf --with-nth=3,4)

[ -z "$output" ] && return

session=$(awk '{print $1}' <<< "$output")
window=$(awk '{print $2}' <<< "$output")

tmux switch-client -t "$session" \; select-window -t "$window"
