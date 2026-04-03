#! /usr/bin/env bash

MIN_WIDTH=140

w=$(tmux display -p '#{client_width}') || exit

# just check if options exist
[[ -z "$(tmux display -p '#{@window_status}')" ]] && exit
[[ -z "$(tmux display -p '#{@window_current_status}')" ]] && exit

small_format="#[bg=default,fg=#{@white}] #I "
small_current_format="#[bg=#{@black3},fg=#{@white}] #I #[bg=#{@black2}] #W "

if (( w <= "$MIN_WIDTH" )); then
  tmux set -g window-status-format "$small_format"
  tmux set -g window-status-current-format "$small_current_format"
else
  tmux set -g window-status-format "#{E:@window_status}"
  tmux set -g window-status-current-format "#{E:@window_current_status}"
fi
