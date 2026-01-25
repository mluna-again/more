#! /usr/bin/env bash

prefix=$(tmux show-options -gv prefix)

case "$1" in
  banner)
    tmux switch-client -l
    ;;

  session_name)
    tmux select-window -l &>/dev/null
    true
    ;;

ZOOM)
  tmux resize-pane -Z
  ;;

  *)
    ;;
esac
