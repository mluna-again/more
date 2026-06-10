#! /usr/bin/env bash

source ~/.local/scripts/bin/tmux_util.sh || exit

is_empty=1
while read -r pid; do
  if ! is_pane_empty "$pid"; then
    is_empty=0
    break
  fi
done < <(tmux list-panes -F '#{pane_pid}')

if [ "$is_empty" -eq 1 ]; then
  tmux kill-window
else
  response=$(tmux_prompt "Are you sure (kill-window)?")
  if [[ ! "${response,,}" =~ ^y(es)?$ ]]; then
    exit 0
  fi
  tmux kill-window
fi
