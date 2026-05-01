#! /usr/bin/env bash

source ~/.local/scripts/bin/tmux_util.sh || exit

marked_pane=$(tmux list-panes -a -f '#{pane_marked}' -F '(#{session_name}.#{pane_current_command})')
if [ -z "$marked_pane" ]; then
  marked_pane="(No pane marked)"
fi

KILL_SERVER="TMUX: kill server"
SWITCH_PREFIX="TMUX: switch prefix"
DUMP_CMDS="TMUX: dump current window commands"
REMBER="TMUX: Add sticky note"
NOTREMBER="TMUX: Remove sticky note"
CLEAR_PANE="TMUX: clear scrollback buffer"
CLEAR_TAG="TMUX: remove tag"
REARRANGE_FIRST="Panes: move empty first"
REARRANGE_LAST="Panes: move empty last"
BREAK_PANE="Panes: break pane"
JOIN_PANE="Panes: join pane $marked_pane"
CLEAR_PANES="Panes: clear panes"
CLOSE_EMPTY_PANELS="Panes: close empty panels"
MAKE_PANES="Panes: make panes"
SAVE_SESSION="Sessions: save current"
EDIT_SESSION="Sessions: edit current"
KILL_SESSION="Sessions: kill session"
SAVER="Utilities: screen saver"
START_APPS="Automation: start applications"
STOP_APPS="Automation: Stop applications"
TODO="Utilities: TODOs"
MATRIX="Random: matrix"
TOGGLE_BORDERS="Borders: toggle"
CMD_BORDERS="Borders: display running command"
PATH_BORDERS="Borders: display current path"
PRIV_MODE="Utilities: private mode"
FORWARD_PREFIX="Utilities: fordward prefix"
RELOAD_CONFIG="TMUX: reload config"
AUTISM="Random: autism"

items=$(cat - <<EOF | sort -h
$KILL_SERVER
$DUMP_CMDS
$SWITCH_PREFIX
$REMBER
$NOTREMBER
$REARRANGE_FIRST
$REARRANGE_LAST
$CLEAR_PANE
$CLEAR_TAG
$BREAK_PANE
$JOIN_PANE
$SAVE_SESSION
$EDIT_SESSION
$KILL_SESSION
$SAVER
$START_APPS
$STOP_APPS
$CLEAR_PANES
$TODO
$MATRIX
$CLEAR_MARKS
$CLOSE_EMPTY_PANELS
$MAKE_PANES
$TOGGLE_BORDERS
$CMD_BORDERS
$PATH_BORDERS
$PRIV_MODE
$FORWARD_PREFIX
$RELOAD_CONFIG
$AUTISM
EOF
)

response=$(tmux_fzf "Command palette" "$items")
[ -z "$response" ] && exit 0

case "$response" in
  "$TOGGLE_BORDERS") ~/.local/scripts/bin/tmux_toggle_panel_borders.sh ;;
  "$CMD_BORDERS") ~/.local/scripts/bin/tmux_panel_cmd.sh ;;
  "$DUMP_CMDS") ~/.local/scripts/bin/tmux_dump_cmds.sh ;;
  "$REMBER") ~/.local/scripts/bin/tmux_rember_add.sh ;;
  "$NOTREMBER") rm ~/.cache/tmux_rember.sh || true ;;
  "$PATH_BORDERS") ~/.local/scripts/bin/tmux_panel_path.sh ;;
  "$REARRANGE_FIRST") ~/.local/scripts/bin/tmux_rearrange_panes.sh first ;;
  "$REARRANGE_LAST") ~/.local/scripts/bin/tmux_rearrange_panes.sh last ;;
  "$CLEAR_PANE") tmux clear-history -t .;;
  "$CLEAR_TAG") ~/.local/scripts/bin/tmux_tag_clear.sh;;
  "$BREAK_PANE") tmux break-pane -a ;;
  "$JOIN_PANE") tmux join-pane || true ;;
  "$SWITCH_PREFIX") ~/.local/scripts/bin/tmux_toggle_prefix.sh;;
  "$KILL_SERVER") ~/.local/scripts/bin/tmux_kill_server.sh;;
  "$SAVE_SESSION") ~/.local/scripts/bin/tmux_session_save.sh;;
  "$EDIT_SESSION") ~/.local/scripts/bin/tmux_session_edit.sh;;
  "$KILL_SESSION") ~/.local/scripts/bin/tmux_session_kill.sh;;
  "$SAVER") ~/.local/scripts/bin/tmux_samurai.sh ;;
  "$START_APPS") ~/.local/scripts/bin/tmux_start_apps.sh ;;
  "$STOP_APPS") ~/.local/scripts/bin/tmux_stop_apps.sh ;;
  "$CLEAR_PANES") ~/.local/scripts/bin/tmux_clear_everypane.sh ;;
  "$TODO") ~/.local/scripts/bin/tmux_goto_todo.sh ;;
  "$MATRIX") ~/.local/scripts/bin/tmux_matrix.sh ;;
  "$MAKE_PANES") ~/.local/scripts/bin/tmux_make_panels.sh ;;
  "$CLOSE_EMPTY_PANELS") ~/.local/scripts/bin/tmux_close_empty_panels.sh ;;
  "$PRIV_MODE") ~/.local/scripts/bin/tmux_priv.sh ;;
  "$FORWARD_PREFIX") ~/.local/scripts/bin/tmux_toggle_prefix.sh ;;
  "$RELOAD_CONFIG") ~/.local/scripts/bin/tmux_reload.sh ;;
  "$AUTISM") ~/.local/scripts/bin/tmux_hacktheworld.sh ;;
esac
