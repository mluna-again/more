#! /usr/bin/env bash

source ~/.local/scripts/bin/tmux_util.sh || exit

last_one() {
  local count
  count=$(tmux list-panes | wc -l)

  [ "$count" -eq 1 ]
}

response=$(tmux_prompt "Are you sure?")
if ! [[ "${response,,}" =~ y(es)? ]]; then
  exit 0
fi

while read -r pane; do
  id=$(awk '{print $1}' <<< "$pane")
  cmd=$(awk '{print $2}' <<< "$pane")

  looks_empty "$cmd" || continue
  last_one && continue

  tmux kill-pane -t "$id"
done < <(tmux list-panes -F '#{pane_id} #{pane_current_command}')

true
