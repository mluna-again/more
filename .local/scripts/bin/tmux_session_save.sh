#! /usr/bin/env bash

source ~/.local/scripts/bin/tmux_util.sh || exit

name=$(tmux display -p '#{session_name}') || exit
[ -z "$name" ] && exit

path="$HOME/.local/tmuxp/${name}.yaml"
if [ -f "$path" ]; then
  response=$(tmux_prompt "Session already exists. Overwrite?")
  if [[ ! "${response,,}" =~ ^y(es)?$ ]]; then
    exit 0
  fi
fi

output=$(tmuxp freeze "$(tmux display -p '#{session_name}')" --yes --save-to "$path" --workspace-format yaml 2>&1)
if [ "$?" -ne 0 ]; then
  tmux display-popup "$output"
  exit 0
fi

name_updated=$(sed "s/^session_name:.*\$/session_name: $name/" "$path")
echo "$name_updated" | tee "$path" >/dev/null
tmux_alert "Session saved."
