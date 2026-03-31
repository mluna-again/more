#! /usr/bin/env bash

case "$1" in
  banner)
    ~/.local/scripts/bin/tmux_tmux_menu.sh
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
