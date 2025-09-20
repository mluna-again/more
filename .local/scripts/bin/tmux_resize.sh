#! /usr/bin/env bash

_STEP=5

while true; do
  key=$(tmux command-prompt -1 -p "Resize (hjkl). C-c/q to quit." 'display -p %%')
  [ -z "$key" ] && exit 0

  case "$key" in
    q)
      break
      ;;
    k)
      tmux resize-pane -t . -U "$_STEP"
      ;;
    j)
      tmux resize-pane -t . -D "$_STEP"
      ;;
    l)
      tmux resize-pane -t . -R "$_STEP"
      ;;
    h)
      tmux resize-pane -t . -L "$_STEP"
      ;;
  esac
done

true
