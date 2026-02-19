#! /usr/bin/env bash

source ~/.local/scripts/bin/tmux_util.sh || exit

target=$(tmux list-panes -F '#{pane_id} #{pane_current_command} @ #{pane_current_path}' | mina -title="Find pane" -icon="" -nth=1,4 | awk '{print $1}')
[ -z "$target" ] && exit 0

tmux select-pane -t "$target"
