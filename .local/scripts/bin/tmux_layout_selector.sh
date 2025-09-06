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

# swap even horizontal/vertical because default is too confusing
case "$layout" in
  "Even Horizontal")
    layout="Even Vertical"
    ;;

  "Even Vertical")
    layout="Even Horizontal"
    ;;
esac
layout="$(sed 's/ /-/g' <<< "$layout" | tr '[:upper:]' '[:lower:]')"


tmux select-layout "$layout" && \
  tmux swap-pane -s . -t 0 && \
  tmux select-pane -t 0
