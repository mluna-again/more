#! /usr/bin/env bash

case "$1" in
  banner)
    ~/.local/scripts/bin/tmux_tmux_menu.sh
    ;;

  session_name)
    ~/.local/scripts/bin/tmux_session_menu.sh
    ;;

  CLOCK)
    tmux clock-mode
    ;;

  ZOOM)
    tmux resize-pane -Z
    ;;

  *)
    ;;
esac
