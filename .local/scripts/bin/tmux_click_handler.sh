#! /usr/bin/env bash

case "$1" in
  HOSTNAME)
    ~/.local/scripts/bin/tmux_tmux_menu.sh
    ;;

  SESSION_NAME)
    ~/.local/scripts/bin/tmux_session_menu.sh
    ;;

  CLOCK)
    tmux clock-mode
    ;;

  TMUX_BANNER)
    tmux resize-pane -Z
    ;;

  *)
    ;;
esac
