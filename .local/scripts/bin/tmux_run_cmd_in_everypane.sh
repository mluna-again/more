#! /usr/bin/env bash

_SHELLS="bash fish sh zsh"

cmd=$(tmux command-prompt 'display -p "%%%"')
[ -z "$cmd" ] && exit 0

while read -r pane; do
  id="$(awk '{print $1}' <<< "$pane")"
  shell="$(awk '{print $2}' <<< "$pane")"
  if grep -qiv "$shell" <<< "$_SHELLS"; then
    continue
  fi

  tmux send-keys -t "$id" "$cmd" Enter
done < <(tmux list-panes -F "#{pane_id} #{pane_current_command}")

true
