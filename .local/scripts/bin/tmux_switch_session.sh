#! /usr/bin/env bash

source ~/.local/scripts/bin/tmux_util.sh || exit

files=$(get_sessions)
if [ -z "$files" ]; then
  tmux_alert "No session files in ~/.local/tmuxp"
  exit
fi

output=$(
    echo "$files" | \
    grep -v quake | \
    sort -h | \
    mina -title="Search TMUX session" -icon=""
)

[ -z "$output" ] && exit

session=$(awk -F: '{print $1}' <<< "$output" | xargs)
window=$(awk -F: '{print $2}' <<< "$output" | xargs)

[ -z "$session" ] && exit
[ -z "$window" ] && exit

tmux_switch "$session" || exit 0
