#! /usr/bin/env bash

source ~/.local/scripts/bin/tmux_util.sh || exit

if looks_empty "$(tmux display -p '#{pane_current_command}')"; then
  tmux kill-pane
else
  response=$(tmux_prompt "Are you sure (kill-pane)?")
  if [[ ! "${response,,}" =~ ^y(es)?$ ]]; then
    exit 0
  fi
  tmux kill-pane
fi
