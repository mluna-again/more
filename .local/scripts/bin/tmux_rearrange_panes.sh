#! /usr/bin/env bash

source ~/.local/scripts/bin/tmux_util.sh || exit

mode="${1:-first}"

empty=()
nonempty=()
while read -r pane cmd; do
  if looks_empty "$cmd"; then
    empty+=( "$pane" )
  else
    nonempty+=( "$pane" )
  fi
done < <(tmux list-panes -F '#{pane_id} #{pane_current_command}')

count=0
if [ "$mode" = first ]; then
  for pane in "${empty[@]}"; do
    tmux swap-pane -s "$pane" -t "$count"
    (( count++ ))
  done
  for pane in "${nonempty[@]}"; do
    tmux swap-pane -s "$pane" -t "$count"
    (( count++ ))
  done
else
  for pane in "${nonempty[@]}"; do
    tmux swap-pane -s "$pane" -t "$count"
    (( count++ ))
  done
  for pane in "${empty[@]}"; do
    tmux swap-pane -s "$pane" -t "$count"
    (( count++ ))
  done
fi
