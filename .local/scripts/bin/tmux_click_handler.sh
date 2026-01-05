#! /usr/bin/env bash

prefix=$(tmux show-options -gv prefix)

case "$1" in
  banner)
    tmux display-menu -MO hi h 'display hi'
    ;;

  session_name)
    # Scrollable session list
    tmux send-keys -K "$prefix" o
    ;;

  *)
    ;;
esac
