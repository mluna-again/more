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

response=$(tmux command-prompt -1 -p "Are you sure? [N/y] " 'display -p %%')
if ! grep -iq "y" <<< "$response"; then
  exit 0
fi

while read -r pane; do
  id=$(awk '{print $1}' <<< "$pane")
  cmd=$(awk '{print $2}' <<< "$pane")

  looks_empty "$cmd" || continue

  tmux kill-pane -t "$id"
done < <(tmux list-panes -F '#{pane_id} #{pane_current_command}')

true
