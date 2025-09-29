#! /usr/bin/env bash

output=$(tmux list-windows -a -F "#{session_id} #{window_id} #{session_name}: #{window_name}" | mina -nth 2,3 -title="Search a TMUX session" -icon="")

[ -z "$output" ] && exit

session=$(awk '{print $1}' <<< "$output")
window=$(awk '{print $2}' <<< "$output")

[ -z "$session" ] && exit
[ -z "$window" ] && exit

tmux switch-client -t "$session" \; select-window -t "$window"
