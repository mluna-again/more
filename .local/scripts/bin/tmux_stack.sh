#! /usr/bin/env bash

key="$1"
read -r stacked_r < <(tmux display -p '#{@stack_at_right}')
read -r stacked_l < <(tmux display -p '#{@stack_at_left}')
read -r at_right at_left < <(tmux display -p '#{pane_at_right} #{pane_at_left}')

should_resize=
if [ "$stacked_l" = 1 ] && [ "$at_left" = 1 ]; then
  should_resize=1
elif [ "$stacked_r" = 1 ] && [ "$at_right" = 1 ]; then
  should_resize=1
fi

case "$key" in
  STAY)
    tmux resize-pane -y "100%"
    ;;
  j)
    tmux select-pane -D
    [ -n "$should_resize" ] && tmux resize-pane -y "100%"
    ;;
  k)
    tmux select-pane -U
    [ -n "$should_resize" ] && tmux resize-pane -y "100%"
    ;;
esac

true
