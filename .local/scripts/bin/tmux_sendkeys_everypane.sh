#! /usr/bin/env bash

source ~/.local/scripts/bin/tmux_util.sh || exit

keys=$(tmux_ask "Keys" | sed 's|;|\\;|g')
[ -z "$keys" ] && exit 0

while read -r pane; do
  id="$(awk '{print $1}' <<< "$pane")"

  tmux send-keys -t "$id" "$keys" Enter
done < <(tmux list-panes -F "#{pane_id}")
