#! /usr/bin/env bash

layout=$(cat - <<EOF | fzf --ghost="Select Layout" --preview="tmux_layout_preview.sh {}" | xargs
Even Horizontal
Even Vertical
Main Horizontal
Main Horizontal Mirrored
Main Vertical
Main Vertical Mirrored
Tiled
Centered
EOF
)

[ -z "$layout" ] && exit 0

case "$layout" in
  "Centered")
    tmux select-layout "f4d4,205x32,0,0{57x32,0,0[57x16,0,0,55,57x15,0,17,62],87x32,58,0,60,59x32,146,0[59x16,146,0,61,59x15,146,17,63]}" && \
      tmux swap-pane -s . -t 2 && \
      tmux select-pane -t 2
    exit
    ;;
esac

layout="$(sed 's/ /-/g' <<< "$layout" | tr '[:upper:]' '[:lower:]')"

tmux select-layout "$layout" && \
  tmux swap-pane -s . -t 0 && \
  tmux select-pane -t 0
