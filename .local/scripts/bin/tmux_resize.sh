#! /usr/bin/env bash

source ~/.local/scripts/bin/tmux_util.sh || exit

_STEP=5

count=$(tmux display -p '#{window_panes}') || exit
if (( count < 2 )); then
  tmux_alert "Only one pane open."
  exit 0
fi

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
