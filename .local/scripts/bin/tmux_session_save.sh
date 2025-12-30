#! /usr/bin/env bash

source ~/.local/scripts/bin/tmux_util.sh || exit

name=$(tmux_ask "Session name") || exit
[ -z "$name" ] && exit

sessions=$(get_sessions)

if grep -iq "$name" <<< "$sessions"; then
  tmux_alert "Session already exists."

  exit 0
fi

path="$HOME/.local/tmuxp/${name}.yaml"
output=$(tmuxp freeze "$(tmux display -p '#{session_name}')" --yes --save-to "$path" --workspace-format yaml 2>&1)
if [ "$?" -ne 0 ]; then
  tmux display-popup "$output"
  exit 0
fi

name_updated=$(sed "s/^session_name:.*\$/session_name: $name/" "$path")
echo "$name_updated" | tee "$path" >/dev/null
tmux_alert "Session saved."
