#! /usr/bin/env bash

height="$(tmux display -p '#{client_height}')"
pane_count="$(tmux list-panes | wc -l)"
remaining_height="$(( height - 1 - pane_count ))" # 1 = statusbar

case "$1" in
  j)
    tmux select-pane -D
    ;;
  k)
    tmux select-pane -D
    ;;
esac

while read -r id at_right active; do
  if [ "$at_right" -ne 1 ]; then
    continue
  fi
  if [ "$active" -eq 1 ]; then
    tmux resize-pane -t "$id" -y "$remaining_height"
  else
    tmux resize-pane -t "$id" -y 1
  fi
done < <(tmux list-panes -F '#{pane_id} #{pane_at_right} #{pane_active}')
