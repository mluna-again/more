#! /usr/bin/env bash

if [[ "$(tmux display -p '#{pane_input_off}')" = 1 ]]; then
  tmux select-pane -e
else
  tmux select-pane -d
fi
