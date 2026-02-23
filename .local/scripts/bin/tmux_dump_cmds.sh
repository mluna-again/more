#! /usr/bin/env bash

source ~/.local/scripts/bin/tmux_util.sh || exit

# Dumps current window's panes commands.
# This only works if your shell is correctly setting the title with the running command + args.
# This script assumes the following format: [<date>] <cmd> <args> @ <path>
# Outputs the following: <path>@<cmd> <args>

cmds=$(
  tmux list-panes -F '#{pane_title}' | \
    sed 's|\[.*\]||' | \
    awk -F@ '{ gsub(/^ */, "", $1); gsub(/ *$/, "", $1); printf "%s@%s\n", $2, $1 }'
)

if [ -z "$cmds" ]; then
  tmux_alert "Could not retrieve CMDs"
  exit 0
fi

path=$(tmux display -p '#{pane_current_path}')
path=$(tmux_ask 'Destination dir' "$path")
[ -z "$path" ] && exit
path="$path/cmds.xdo"

if [ -f "$path" ]; then
  tmux_alert "File $(basename "$path") already exists (appending)."
  echo "----" >> "$path"
fi

if ! echo "$cmds" >> "$path"; then
  tmux_alert "Something went wrong"
  exit 0
fi
