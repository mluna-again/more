#! /usr/bin/env bash

source ~/.local/scripts/bin/tmux_util.sh || exit

TSESSION=crush
CRUSH_DIR="$HOME/.local/crush"
if [ ! -d "$CRUSH_DIR" ]; then
  mkdir "$CRUSH_DIR" || exit
fi

current_session=$(tmux display -p '#{session_name}') || exit

if ! tmux switch-client -t "$TSESSION"; then
  tmux new-session -d -c "$CRUSH_DIR" -n "$TSESSION" -s "$TSESSION"
  tmux switch-client -t "$TSESSION"
  tmux send-keys -t "$pane" crush Enter
  exit 0
fi

read -r pane cmd < <(tmux display -p '#{pane_id} #{pane_current_command}' | head -1) || exit

if [ "$current_session" = "$TSESSION" ] && [ "$cmd" = crush ]; then
  tmux switch-client -l
  exit 0
fi

pane_count=$(tmux list-panes | wc -l) || exit
if (( pane_count > 1 )); then
  tmux_alert "More than one pane open."
  exit 0
fi

if ! looks_empty "$cmd"; then
  if [ "$cmd" != crush ]; then
    tmux_alert "Another program running."
    exit 0
  fi

  exit 0
fi

tmux send-keys -t "$pane" crush Enter
