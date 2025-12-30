#! /usr/bin/env bash

source ~/.local/scripts/bin/tmux_util.sh || exit

SAVER="Screen saver"
CRUSH=Crush
START_APPS="Start applications"
STOP_APPS="Stop applications"
RUN_CMD="Run command"
SEND_KEYS="Send keys"
CLEAR_PANES="Clear panes"
TODO=Todo
MATRIX=Matrix
CLEAR_MARKS="Remove all marks"
CLOSE_EMPTY_PANELS="Close empty panels"
TOGGLE_BORDERS="Toggle panel borders"
PRIV_MODE="Private mode"
FORWARD_PREFIX="Fordward prefix"
RELOAD_CONFIG="Reload TMUX config"
AUTISM="Autism"

items=$(cat - <<EOF | sort -h
$SAVER
$CRUSH
$START_APPS
$STOP_APPS
$RUN_CMD
$SEND_KEYS
$CLEAR_PANES
$TODO
$MATRIX
$CLEAR_MARKS
$CLOSE_EMPTY_PANELS
$TOGGLE_BORDERS
$PRIV_MODE
$FORWARD_PREFIX
$RELOAD_CONFIG
$AUTISM
EOF
)

response=$(tmux_fzf "Command palette" "$items")
[ -z "$response" ] && exit 0

case "$response" in
  "$SAVER") ~/.local/scripts/bin/tmux_samurai.sh ;;
  "$CLEAR_MARKS") ~/.local/scripts/bin/tmux_mark_rm_all.sh ;;
  "$CRUSH") ~/.local/scripts/bin/tmux_crush.sh ;;
  "$START_APPS") ~/.local/scripts/bin/tmux_start_apps.sh ;;
  "$STOP_APPS") ~/.local/scripts/bin/tmux_stop_apps.sh ;;
  "$RUN_CMD") ~/.local/scripts/bin/tmux_run_cmd_in_everypane.sh ;;
  "$SEND_KEYS") ~/.local/scripts/bin/tmux_sendkeys_everypane.sh ;;
  "$CLEAR_PANES") ~/.local/scripts/bin/tmux_clear_everypane.sh ;;
  "$TODO") ~/.local/scripts/bin/tmux_goto_todo.sh ;;
  "$MATRIX") ~/.local/scripts/bin/tmux_matrix.sh ;;
  "$CLOSE_EMPTY_PANELS") ~/.local/scripts/bin/tmux_close_empty_panels.sh ;;
  "$TOGGLE_BORDERS") ~/.local/scripts/bin/tmux_toggle_panel_borders.sh ;;
  "$PRIV_MODE") ~/.local/scripts/bin/tmux_priv.sh ;;
  "$FORWARD_PREFIX") ~/.local/scripts/bin/tmux_toggle_prefix.sh ;;
  "$RELOAD_CONFIG") ~/.local/scripts/bin/tmux_reload.sh ;;
  "$AUTISM") ~/.local/scripts/bin/tmux_hacktheworld.sh ;;
esac
