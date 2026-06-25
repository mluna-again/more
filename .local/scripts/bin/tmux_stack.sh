#! /usr/bin/env bash

key="$1"
case "$key" in
  STAY)
    tmux resize-pane -y "100%"
    ;;
  j)
    tmux select-pane -D
    tmux resize-pane -y "100%"
    ;;
  k)
    tmux select-pane -U
    tmux resize-pane -y "100%"
    ;;
esac

true
