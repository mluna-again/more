#! /usr/bin/env bash

tmux switch-client -n
if [ "$(tmux display -p '#{session_name}')" = quake ]; then
  tmux switch-client -n
fi
