#! /usr/bin/env bash

source ~/.local/scripts/bin/tmux_util.sh || exit

# Dumps current window's panes commands.
# This only works if your shell is correctly setting the title with the running command + args.
# This script assumes the following format: [<date>] <cmd> <args> @ <path>
# Outputs the following: <path>@<cmd> <args>

cmds=$(
  tmux list-panes -F '#{pane_title}' | \
    sed 's|\[.*\]||' | \
    awk -F@ '{ gsub(/^ */, "", $1); gsub(/ *$/, "", $1); gsub(/^ */, "", $2); gsub(/ *$/, "", $2); printf "%s@%s\n", $2, $1 }'
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
  response=$(tmux_prompt "File $(basename "$path") already exists. What do I do? [r(eplace), n(nothing), a(ppend)] " "[N/r/a]")
  [ -z "$response" ] && exit 0

  if grep -Eiq "^r(replace)?$" <<< "$response"; then
    if ! echo "$cmds" > "$path"; then
      tmux_alert "Something went wrong"
      exit 0
    fi
  elif grep -Eiq "^n(othing)?$" <<< "$response"; then
    exit 0
  elif grep -Eiq "^a(ppend)?$" <<< "$response"; then
    echo "-----" >> "$path"
    if ! echo "$cmds" >> "$path"; then
      tmux_alert "Something went wrong"
      exit 0
    fi
  else
    tmux_alert "Invalid response."
    exit 0
  fi
else
  if ! echo "$cmds" > "$path"; then
    tmux_alert "Something went wrong"
    exit 0
  fi
fi
