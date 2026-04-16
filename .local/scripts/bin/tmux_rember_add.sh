#! /usr/bin/env bash

source ~/.local/scripts/bin/tmux_util.sh || exit

current=$(cat ~/.cache/tmux_rember.sh 2>/dev/null)
note=$(tmux_ask "What's on your mind?" "$current") || exit
[ -z "$note" ] && exit 0

echo "$note" > ~/.cache/tmux_rember.sh
