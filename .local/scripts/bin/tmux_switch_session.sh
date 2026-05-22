#! /usr/bin/env bash

source ~/.local/scripts/bin/tmux_util.sh || exit

output=$(
    get_sessions 1 |
    mina -title="Search TMUX session" -icon="" |
    sed 's| (lazy)$||'
)

[ -z "$output" ] && exit

session=$(awk -F: '{print $1}' <<< "$output" | xargs)
window=$(awk -F: '{print $2}' <<< "$output" | xargs)

[ -z "$session" ] && exit
[ -z "$window" ] && exit

tmux_switch "$session" "$window" || exit
