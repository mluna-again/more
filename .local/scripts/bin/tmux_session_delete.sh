#! /usr/bin/env bash

source ~/.local/scripts/bin/tmux_util.sh || exit

BASE_DIR="$HOME/.local/tmuxp"

sessions=$(get_saved_sessions "$BASE_DIR" | awk -F: '{print $1}' | sort | uniq)
if [ -z "$sessions" ]; then
  tmux_alert "Something went wrong while feching sessions."
  exit 0
fi

name=$(tmux_fzf "Delete session" "$sessions") || exit
[ -z "$name" ] && exit 0

output=$(rm -f "${BASE_DIR}/${name}."{yml,yaml} 2>&1)
# shellcheck disable=SC2181
if [ "$?" -ne 0 ]; then
  tmux_alert "Something went wrong: $output."
  exit 0
fi

tmux_alert "Session deleted."
