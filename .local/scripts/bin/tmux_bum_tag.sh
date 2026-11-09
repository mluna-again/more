#! /usr/bin/env bash

source ~/.local/scripts/bin/tmux_util.sh || exit

skip_title="$1"

read -r pane description < <(tmux display -p '#{pane_id} #{session_name}:#{window_name}')

title=
if [ -z "$skip_title" ]; then
  title="$(tmux_ask "Title")"
fi
[ -z "$title" ] && title="$(tmux display -p '#{pane_title}')"

bum -color 2 -pane "$pane" -description "$description" add "$title"
