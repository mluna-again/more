#! /usr/bin/env bash

source ~/.local/scripts/bin/tmux_util.sh || exit

key="$(tmux command-prompt -1 -N -p 'Press a number from 1 to 10.' 'display -p %%')"
[ -z "$key" ] && exit 1

case "$key" in
  0)
    tmux bind -Troot F10 run-shell "~/.local/scripts/bin/tmux_tag_pane.sh F10" \; display 'Key cleared.'
    ;;
  1|2|3|4|5|6|7|8|9)
    tmux bind -Troot F"$key" run-shell "~/.local/scripts/bin/tmux_tag_pane.sh F$key" \; display 'Key cleared.'
    ;;
  *)
    tmux_alert "Invalid key."
    ;;
esac

