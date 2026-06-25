#! /usr/bin/env bash

key="$1"
case "$key" in
  j)
    tmux select-pane -D
    ;;
  k)
    tmux select-pane -U
    ;;
esac

read -r stacked_r < <(tmux display -p '#{@stack_at_right}')
read -r stacked_l < <(tmux display -p '#{@stack_at_left}')
read -r height at_right at_left < <(tmux display -p '#{client_height} #{pane_at_right} #{pane_at_left}')

if [ "$stacked_l" = 1 ] && [ "$at_left" = 1 ]; then
  pane_count="$(tmux list-panes -f '#{pane_at_left}' | wc -l)"
  remaining_height="$(( height - 1 - pane_count ))"
  tmux resize-pane -y "$remaining_height"
elif [ "$stacked_r" = 1 ] && [ "$at_right" = 1 ]; then
  pane_count="$(tmux list-panes -f '#{pane_at_right}' | wc -l)"
  remaining_height="$(( height - 1 - pane_count ))"
  tmux resize-pane -y "$remaining_height"
else
  true
fi
