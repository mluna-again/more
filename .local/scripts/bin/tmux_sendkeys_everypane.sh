#! /usr/bin/env bash

keys=$(tmux command-prompt 'display -p "%%%"' | sed 's|;|\\;|g')
[ -z "$keys" ] && exit 0

while read -r pane; do
  id="$(awk '{print $1}' <<< "$pane")"

  tmux send-keys -t "$id" "$keys" Enter
done < <(tmux list-panes -F "#{pane_id}")
