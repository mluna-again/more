#! /usr/bin/env bash

tmux display-menu -x 0 -y S -M -O \
  "Change prefix" "" "run-shell ~/.local/scripts/bin/tmux_toggle_prefix.sh" \
  "Detach" "" "detach-client"
