#! /usr/bin/env bash

source ~/.local/scripts/bin/tmux_util.sh || exit

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

pane_count=$(panes_count) || exit

case "$layout" in
  "Centered")
    if (( pane_count > 5 )); then
      tmux_alert "Too many panes for this layout."
      exit 0
    fi
    if (( pane_count < 2 )); then
      tmux_alert "Not enough panes for this layout."
      exit 0
    fi
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
