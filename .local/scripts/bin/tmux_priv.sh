#! /usr/bin/env bash

_SHELLS=(
  fish
  bash
  sh
  zsh
)

looks_empty() {
  for shell in "${_SHELLS[@]}"; do
    grep -iq "$shell" <<< "$1" && return 0
  done

  return 1
}

while read -r id cmd; do
  looks_empty "$cmd" || continue
  tmux send-keys -t "$id" fish Space -P Enter
  tmux send-keys -t "$id" C-l
done < <(tmux list-panes -F '#{pane_id} #{pane_current_command}')
