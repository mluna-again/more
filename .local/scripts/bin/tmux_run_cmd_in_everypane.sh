#! /usr/bin/env bash

source ~/.local/scripts/bin/tmux_util.sh || exit

cmd=$(tmux command-prompt -p 'Run command:' 'display -p "%%%"' | sed 's|;|\\;|g')
[ -z "$cmd" ] && exit 0

while read -r pane; do
  id="$(awk '{print $1}' <<< "$pane")"
  shell="$(awk '{print $2}' <<< "$pane")"
  looks_empty "$shell" || continue

  tmux send-keys -t "$id" "$cmd" Enter
done < <(tmux list-panes -F "#{pane_id} #{pane_current_command}")

true
