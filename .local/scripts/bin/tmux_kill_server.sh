#! /usr/bin/env bash

source ~/.local/scripts/bin/tmux_util.sh || exit

response=$(tmux_prompt "Are you sure?")
if ! [[ "${response,,}" =~ y(es)? ]]; then
  exit 0
fi

tmux kill-server
