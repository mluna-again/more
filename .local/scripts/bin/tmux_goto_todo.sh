#! /usr/bin/env bash

source ~/.local/scripts/bin/tmux_util.sh || exit

_TODO_DIR="$HOME/Org"

if ! [ -d "$_TODO_DIR" ]; then
  mkdir "$_TODO_DIR" || exit
fi

current_session=$(tmux display -p '#{session_name}') || exit
if ! tmux switch-client -t todo; then
  tmux new-session -d -c "$_TODO_DIR" -n emacs -s todo
  tmux switch-client -t todo
  tmux send-keys -t todo emacsclient Space -a Space '' Space --tty Space todo.org Enter
  exit 0
fi

read -r pane cmd < <(tmux display -p '#{pane_id} #{pane_current_command}' | head -1) || exit

if [ "$current_session" = todo ] && [ "$cmd" = emacsclient ]; then
  tmux switch-client -l
  exit 0
fi

pane_count=$(tmux list-panes -t todo | wc -l)
if (( pane_count > 1 )); then
  tmux display "More than one pane open."
  exit 0
fi

if ! looks_empty "$cmd"; then
  if [ "$cmd" != emacsclient ]; then
    tmux display "Another program running."
    exit 0
  fi

  exit 0
fi

tmux send-keys -t "$pane" emacsclient Space -a Space \'\' Space --tty Space "$_TODO_DIR"/todo.org Enter
