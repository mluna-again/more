#! /usr/bin/env bash

tmux switch-client -p
if [ "$(tmux display -p '#{session_name}')" = quake ]; then
  tmux switch-client -p
fi
