#! /usr/bin/env bash

source ~/.local/scripts/bin/tmux_util.sh || exit

pid="$(tmux display -p '#{pane_pid}')"
if [ -z "$pid" ]; then
  tmux_alert "PID not found"
  exit 0
fi

ppid="$(pgrep -P "$pid" | head -n 1)"
if [ -z "$ppid" ]; then
  tmux_alert "Parent PID not found"
  exit 0
fi

kill "$ppid" || exit 0

tmux send-key Enter
