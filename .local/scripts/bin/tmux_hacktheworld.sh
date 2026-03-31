#! /usr/bin/env bash

source ~/.local/scripts/bin/tmux_util.sh || exit

missing_deps=""

command -v chafa &>/dev/null || missing_deps="chafa ${missing_deps}"
command -v cava &>/dev/null || missing_deps="cava ${missing_deps}"

if [ -n "$missing_deps" ]; then
  tmux display "Missing deps: ${missing_deps}"
  exit 0
fi

while read -r pane; do
  cmd=$(awk '{print $1}' <<< "$pane")
  if ! looks_empty "$cmd"; then
    tmux display "Not all panes are empty. Bye."
    exit 0
  fi
done < <(tmux list-panes -F '#{pane_current_command} #{pane_id}')

tmux split-window -c '#{pane_current_path}' -h -l 25% fish -C cmatrix
tmux split-window -c '#{pane_current_path}' -v -l 30% vibe
tmux select-pane -t 0
tmux split-window -c '#{pane_current_path}' -v -l 20% cava
tmux select-pane -t 0
sleep 0.3
tmux send-keys -t 0 nvim Enter
