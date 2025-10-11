#! /usr/bin/env bash

source ~/.local/scripts/bin/tmux_util.sh || exit

SAVER="Screen saver"
GEMMA=Gemma
START_APPS="Start applications"
STOP_APPS="Stop applications"
RUN_CMD="Run command"
SEND_KEYS="Send keys"
CLEAR_PANES="Clear panes"
TODO=Todo
MATRIX=Matrix
CLOSE_EMPTY_PANELS="Close empty panels"
TOGGLE_BORDERS="Toggle panel borders"
PRIV_MODE="Private mode"
FORWARD_PREFIX="Fordward prefix"
RELOAD_CONFIG="Reload TMUX config"
AUTISM="Autism"

items=$(cat - <<EOF
$SAVER@Space
$GEMMA@g
$START_APPS@s
$STOP_APPS@S
$RUN_CMD@r
$SEND_KEYS@k
$CLEAR_PANES@C
$TODO@m
$MATRIX@M
$CLOSE_EMPTY_PANELS@X
$TOGGLE_BORDERS@P
$PRIV_MODE@p
$FORWARD_PREFIX@*
$RELOAD_CONFIG@R
$AUTISM@$
EOF
)

response=$(tmux_menu "Command palette" "$items")
[ -z "$response" ] && exit 0

case "$response" in
  "$SAVER") ~/.local/scripts/bin/tmux_samurai.sh ;;
  "$GEMMA") ~/.local/scripts/bin/tmux_gemma.sh ;;
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
