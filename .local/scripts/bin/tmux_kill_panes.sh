#! /usr/bin/env bash

source ~/.local/scripts/bin/tmux_util.sh || exit

panes_with_content=0

while read -r cmd; do
  if ! looks_empty "$cmd"; then
    panes_with_content=1
    break
  fi
done < <(tmux list-panes -F '#{pane_current_command}')

pane_count=$(tmux list-panes -t . | wc -l)

if [ "$panes_with_content" -eq 1 ] && (( pane_count > 1 )); then
  response=$(tmux_prompt "Are you sure? [N/y]")
  if [ "${response,,}" != y ]; then
    exit 0
  fi
fi

tmux kill-pane -a -t .
