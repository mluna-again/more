#! /usr/bin/env bash

source ~/.local/scripts/bin/tmux_util.sh || exit

# Dumps current window's panes commands.
# This only works if your shell is correctly setting the title with the running command + args.
# This script assumes the following format: [<date>] <cmd> <args> @ <path>

cmds=$(
  tmux list-panes -F '#{pane_title}' | \
    sed 's|\[.*\]||' | \
    awk -F@ '{ gsub(/^ */, "", $1); gsub(/ *$/, "", $1); print $1 }'
)

if [ -z "$cmds" ]; then
  tmux_alert "Could not retrieve CMDs"
  exit 0
fi

path=$(tmux display -p '#{pane_current_path}/cmds.xdo')
path=$(tmux_ask 'Destination' "$path")
[ -z "$path" ] && exit

if [ -f "$path" ]; then
  tmux_alert "File already exists"
  exit 0
fi

if ! echo "$cmds" >> "$path"; then
  tmux_alert "Something went wrong"
  exit 0
fi
