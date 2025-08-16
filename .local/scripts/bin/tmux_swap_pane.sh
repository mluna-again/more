#! /usr/bin/env bash

source=$(tmux display -p -F '#{pane_id} #{pane_active}' | awk '$2 == "1" {print $1}' | xargs) || exit
target=$(tmux display-panes -d 0 'display -p %%' | xargs) || exit
[ -z "$target" ] && exit 0

tmux swap-pane -s "$source" -t "$target"
tmux select-pane -t "$source"
