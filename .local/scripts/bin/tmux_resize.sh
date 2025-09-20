#! /usr/bin/env bash

while true; do
  key=$(tmux command-prompt -1 -p "Resize (hjkl). C-c/q to quit." 'display -p %%')
  [ -z "$key" ] && exit 0

  case "$key" in
    q)
      break
      ;;
    k)
      tmux resize-pane -t . -U 10
      ;;
    j)
      tmux resize-pane -t . -D 10
      ;;
    l)
      tmux resize-pane -t . -R 10
      ;;
    h)
      tmux resize-pane -t . -L 10
      ;;
  esac
done

true
