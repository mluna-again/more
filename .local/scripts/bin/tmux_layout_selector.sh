#! /usr/bin/env bash

layout=$(cat - <<EOF | fzf --ghost="Select Layout" --preview="tmux_layout_preview.sh {}" | xargs
Even Horizontal
Even Vertical
Main Horizontal
Main Horizontal Mirrored
Main Vertical
Main Vertical Mirrored
Tiled
EOF
)

[ -z "$layout" ] && exit 0

tmux select-layout "$(sed 's/ /-/g' <<< ${layout,,})" && \
  tmux swap-pane -s . -t 0 && \
  tmux select-pane -t 0
