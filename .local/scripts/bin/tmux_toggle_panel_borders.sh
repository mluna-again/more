#! /usr/bin/env bash

current=$(tmux show-options -v -s pane-border-status)
next=""

case "$current" in
  "top")
    next="off"
    ;;

  "bottom")
    next="off"
    ;;

  "off")
    next="top"
    ;;

  "")
    next="top"
    ;;

  *)
    tmux display "Invalid status: $current"
    exit 1
    ;;
esac

tmux set-option -s pane-border-status "$next"
