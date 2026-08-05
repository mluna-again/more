#! /usr/bin/env bash

if [ -z "$1" ]; then
  tmux set-option -wu @window_msg
else
  tmux set-option -w @window_msg "[$1] "
fi
