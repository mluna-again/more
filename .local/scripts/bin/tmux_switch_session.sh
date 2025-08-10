#! /usr/bin/env bash

output=$(tmux list-windows -a -F "#{session_id} #{window_id} #{session_name}: #{window_name}" | \
	fzf --with-nth=3,4 --ghost="Search a TMUX session")

[ -z "$output" ] && exit

session=$(awk '{print $1}' <<< "$output")
window=$(awk '{print $2}' <<< "$output")

[ -z "$session" ] && exit
[ -z "$window" ] && exit

tmux switch-client -t "$session" \; select-window -t "$window"
