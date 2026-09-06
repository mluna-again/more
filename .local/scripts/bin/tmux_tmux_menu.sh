#! /usr/bin/env bash

lsess=$(tmux display -p '#{client_last_session}')
lsess_pref=""
[ -z "$lsess" ] && lsess_pref="-"

tmux display-menu -x 0 -y S -M -O -- \
  "${lsess_pref}Last session (${lsess:-<empty>})" "" "switch-client -l" \
  "-                      " "" "" \
  "Split Vertical (v)" "" "split-window -c '#{pane_current_path}' -h" \
  "Split Horizontal (s)" "" "split-window -c '#{pane_current_path}' -v" \
  "-                      " "" "" \
  "Change prefix" "" "run-shell ~/.local/scripts/bin/tmux_toggle_prefix.sh" \
  "Toggle borders" "" "run-shell ~/.local/scripts/bin/tmux_toggle_panel_borders.sh" \
  "Kill current pane program" "" "run-shell ~/.local/scripts/bin/tmux_kill_fg.sh" \
  "Kill current pane" "" "kill-pane -t ." \
  "-                      " "" "" \
  "Detach" "" "detach-client"
