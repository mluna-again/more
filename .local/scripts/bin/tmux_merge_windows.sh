#! /usr/bin/env bash

source ~/.local/scripts/bin/tmux_util.sh || exit

window_marked="$(tmux list-windows -a -f '#{window_marked_flag}' -F '#{window_id}' | head -n1)"
[ -z "$window_marked" ] && exit 0

while read -r pane; do
  tmux join-pane -s "$pane" \; select-layout tiled
  sleep 0.1
done < <(tmux list-panes -t "$window_marked" -F '#{pane_id}')
