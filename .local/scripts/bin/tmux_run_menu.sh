#! /usr/bin/env bash

source ~/.local/scripts/bin/tmux_util.sh || exit

KILL_SERVER="TMUX: kill server"
SAVE_SESSION="Sessions: save current"
KILL_SESSION="Sessions: kill session by name"
SAVER="Utilities: screen saver"
CRUSH="Utilities: crush"
START_APPS="Automation: start applications"
STOP_APPS="Automation: Stop applications"
RUN_CMD="Automation: run command in every pane"
SEND_KEYS="Automation: send keys to panes"
CLEAR_PANES="Automation: clear panes"
TODO="Utilities: TODOs"
MATRIX="Random: matrix"
CLOSE_EMPTY_PANELS="Automation: close empty panels"
TOGGLE_BORDERS="Utilities: toggle panel borders"
PRIV_MODE="Utilities: private mode"
FORWARD_PREFIX="Utilities: fordward prefix"
RELOAD_CONFIG="TMUX: reload config"
AUTISM="Random: autism"

items=$(cat - <<EOF | sort -h
$KILL_SERVER
$SAVE_SESSION
$KILL_SESSION
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
  "$KILL_SERVER") ~/.local/scripts/bin/tmux_kill_server.sh;;
  "$SAVE_SESSION") ~/.local/scripts/bin/tmux_session_save.sh;;
  "$KILL_SESSION") ~/.local/scripts/bin/tmux_session_kill.sh;;
  "$SAVER") ~/.local/scripts/bin/tmux_samurai.sh ;;
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
