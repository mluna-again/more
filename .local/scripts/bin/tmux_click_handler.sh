#! /usr/bin/env bash

prefix=$(tmux show-options -gv prefix)

case "$1" in
  banner)
    tmux switch-client -l
    ;;

  session_name)
    ~/.local/scripts/bin/tmux_session_menu.sh
    ;;

  ZOOM)
    tmux resize-pane -Z
    ;;

  *)
    ;;
esac
