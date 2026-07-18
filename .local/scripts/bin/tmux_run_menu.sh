#! /usr/bin/env bash

source ~/.local/scripts/bin/tmux_util.sh || exit

BUM_PORT=56569

marked_pane=$(tmux list-panes -a -f '#{pane_marked}' -F '(#{session_name}.#{pane_current_command})')
if [ -z "$marked_pane" ]; then
  marked_pane="(No pane marked)"
fi

marked_window=$(tmux list-windows -a -f '#{window_marked_flag}' -F '(#{session_name}.#{window_name})')
if [ -z "$marked_window" ]; then
  marked_window="(No window marked)"
fi

KILL_SERVER="TMUX: kill server"
SWITCH_PREFIX="TMUX: switch prefix"
DUMP_SESSION="TMUX: dump current session"
REMBER="TMUX: Add sticky note"
NOTREMBER="TMUX: Remove sticky note"
BUM_TAG="BUM: Tag pane"
CLEAR_PANE="TMUX: clear scrollback buffer"
CLEAR_TAG="TMUX: remove key tag"
STACK="Panes: toggle stacked panes"
RENAME_PANE="Panes: rename pane"
RESET_PANE_TITLE="Panes: reset title"
REARRANGE_FIRST="Panes: move empty first"
REARRANGE_LAST="Panes: move empty last"
BREAK_PANE="Panes: break pane"
JOIN_PANE="Panes: join pane $marked_pane"
JOIN_PANES="Panes: join window $marked_window"
CLEAR_PANES="Panes: clear panes"
PANES_COUNT="Panes: display count"
CLOSE_EMPTY_PANELS="Panes: close empty panels"
MAKE_PANES="Panes: make panes"
SAVE_SESSION="Sessions: save current"
EDIT_SESSION="Sessions: edit current"
KILL_SESSION="Sessions: kill session"
DELETE_SESSION="Sessions: delete session"
SAVER="Utilities: screen saver"
START_APPS="Automation: start applications"
STOP_APPS="Automation: Stop applications"
TODO="Utilities: TODOs"
MATRIX="Random: matrix"
TOGGLE_BORDERS="Borders: toggle"
CMD_BORDERS="Borders: display running command"
TITLE_BORDERS="Borders: display title"
PATH_BORDERS="Borders: display current path"
MESSAGE_BORDERS="Borders: display current message"
PRIV_MODE="Utilities: private mode"
RELOAD_CONFIG="TMUX: reload config"
AUTISM="Random: autism"

items=$(cat - <<EOF | sort -h
$KILL_SERVER
$DUMP_SESSION
$SWITCH_PREFIX
$REMBER
$NOTREMBER
$BUM_TAG
$REARRANGE_FIRST
$REARRANGE_LAST
$CLEAR_PANE
$CLEAR_TAG
$STACK
$RENAME_PANE
$RESET_PANE_TITLE
$BREAK_PANE
$JOIN_PANE
$JOIN_PANES
$SAVE_SESSION
$EDIT_SESSION
$KILL_SESSION
$DELETE_SESSION
$SAVER
$START_APPS
$STOP_APPS
$CLEAR_PANES
$PANES_COUNT
$TODO
$MATRIX
$CLEAR_MARKS
$CLOSE_EMPTY_PANELS
$MAKE_PANES
$TOGGLE_BORDERS
$CMD_BORDERS
$TITLE_BORDERS
$PATH_BORDERS
$MESSAGE_BORDERS
$PRIV_MODE
$RELOAD_CONFIG
$AUTISM
EOF
)

if [ -z "$1" ]; then
  response=$(tmux_fzf "Command palette" "$items")
else
  response="$1"
fi
[ -z "$response" ] && exit 0

case "$response" in
  "$DUMP_SESSION") ~/.local/scripts/bin/tmux_session_dump.sh ;;
  "$REMBER") ~/.local/scripts/bin/tmux_rember_add.sh ;;
  "$NOTREMBER") rm ~/.cache/tmux_rember.sh || true ;;
  "$BUM_TAG")
    if [ "$(tmux show-option -pv allow-set-title)" = off ]; then
      read -r pane title description < <(tmux display -p '#{pane_id} #{session_name}:#{window_name}.#{pane_index} #{pane_title}')
    else
      read -r title pane < <(tmux display -p '#{session_name}:#{window_name}.#{pane_index} #{pane_id}')
    fi
    curl -fSs -X POST -d "{\"pane_id\": \"$pane\", \"title\": \"$title\", \"description\": \"$description\", \"color\": \"2\"}" "localhost:${BUM_PORT}/new" >/dev/null
    ;;
  "$TOGGLE_BORDERS") ~/.local/scripts/bin/tmux_toggle_panel_borders.sh ;;
  "$CMD_BORDERS") ~/.local/scripts/bin/tmux_panel_cmd.sh ;;
  "$TITLE_BORDERS") ~/.local/scripts/bin/tmux_panel_title.sh ;;
  "$PATH_BORDERS") ~/.local/scripts/bin/tmux_panel_path.sh ;;
  "$MESSAGE_BORDERS") ~/.local/scripts/bin/tmux_panel_message.sh ;;
  "$REARRANGE_FIRST") ~/.local/scripts/bin/tmux_rearrange_panes.sh first ;;
  "$REARRANGE_LAST") ~/.local/scripts/bin/tmux_rearrange_panes.sh last ;;
  "$CLEAR_PANE") tmux clear-history -t .;;
  "$CLEAR_TAG") ~/.local/scripts/bin/tmux_tag_clear.sh;;
  "$STACK") ~/.local/scripts/bin/tmux_stack_toggle.sh;;
  "$RENAME_PANE") ~/.local/scripts/bin/tmux_rename_pane.sh ;;
  "$RESET_PANE_TITLE")
    tmux set-option -pu allow-set-title
    ;;
  "$BREAK_PANE") tmux break-pane -a ;;
  "$JOIN_PANE") tmux join-pane -h || true ;;
  "$JOIN_PANES") ~/.local/scripts/bin/tmux_merge_windows.sh;;
  "$SWITCH_PREFIX") ~/.local/scripts/bin/tmux_toggle_prefix.sh;;
  "$KILL_SERVER") ~/.local/scripts/bin/tmux_kill_server.sh;;
  "$SAVE_SESSION") ~/.local/scripts/bin/tmux_session_save.sh;;
  "$EDIT_SESSION") ~/.local/scripts/bin/tmux_session_edit.sh;;
  "$KILL_SESSION") ~/.local/scripts/bin/tmux_session_kill.sh;;
  "$DELETE_SESSION") ~/.local/scripts/bin/tmux_session_delete.sh;;
  "$SAVER") ~/.local/scripts/bin/tmux_samurai.sh ;;
  "$START_APPS") ~/.local/scripts/bin/tmux_start_apps.sh ;;
  "$STOP_APPS") ~/.local/scripts/bin/tmux_stop_apps.sh ;;
  "$CLEAR_PANES") ~/.local/scripts/bin/tmux_clear_everypane.sh ;;
  "$PANES_COUNT") tmux display 'Panes count: #{window_panes}' ;;
  "$TODO") ~/.local/scripts/bin/tmux_goto_todo.sh ;;
  "$MATRIX") ~/.local/scripts/bin/tmux_matrix.sh ;;
  "$MAKE_PANES") ~/.local/scripts/bin/tmux_make_panels.sh ;;
  "$CLOSE_EMPTY_PANELS") ~/.local/scripts/bin/tmux_close_empty_panels.sh ;;
  "$PRIV_MODE") ~/.local/scripts/bin/tmux_priv.sh ;;
  "$RELOAD_CONFIG") ~/.local/scripts/bin/tmux_reload.sh ;;
  "$AUTISM") ~/.local/scripts/bin/tmux_hacktheworld.sh ;;
esac
