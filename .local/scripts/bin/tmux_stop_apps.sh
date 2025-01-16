#! /usr/bin/env bash

_SHELLS="bash fish sh zsh"

while read -r pane; do
  id="$(awk '{print $1}' <<< "$pane")"
  shell="$(awk '{print $2}' <<< "$pane")"

  if grep -qi "$shell" <<< "$_SHELLS"; then
    continue
  fi

  tmux send-keys -t "$id" C-c
done < <(tmux list-panes -F '#{pane_id} #{pane_current_command}')

true
