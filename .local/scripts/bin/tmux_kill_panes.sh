#! /usr/bin/env bash

source ~/.local/scripts/bin/tmux_util.sh || exit

current_pane_pid=$(tmux display -p "#{pane_pid}")

panes_with_content=0

while read -r pid; do
  if ! is_pane_empty "$pid"; then
    (( panes_with_content++ ))
  fi
done < <(tmux list-panes -F '#{pane_pid}')

pane_count=$(tmux list-panes -t . | wc -l)

dokill() {
  tmux kill-pane -a -t .
}

# there is only one pane with content, and is the current one
if [ "$panes_with_content" -eq 1 ]; then
  if ! is_pane_empty "$current_pane_pid"; then
    dokill
    exit 0
  fi
fi

if [ "$panes_with_content" -gt 0 ] && (( pane_count > 1 )); then
  response=$(tmux_prompt "Are you sure?")
  if ! [[ "${response,,}" =~ y(es)? ]]; then
    exit 0
  fi
fi

dokill
