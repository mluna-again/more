#! /usr/bin/env bash

lsess=$(tmux display -p '#{client_last_session}')
lsess_pref=""
[ -z "$lsess" ] && lsess_pref="-"

tmux display-menu -x 0 -y S -M -O -- \
  "${lsess_pref}Last session (${lsess:-<empty>})" "" "switch-client -l" \
  "-------" "" "" \
  "Change prefix" "" "run-shell ~/.local/scripts/bin/tmux_toggle_prefix.sh" \
  "Toggle zoom" "" "resize-pane -Z" \
  "Toggle borders" "" "run-shell ~/.local/scripts/bin/tmux_toggle_panel_borders.sh" \
  "Kill current pane" "" "kill-pane -t ." \
  "-------" "" "" \
  "Detach" "" "detach-client"
