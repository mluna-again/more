#! /usr/bin/env bash

tmux set-option -w pane-border-format '#[bg=#{?pane_active,#{@yellow},#{@black2}},fg=#{?pane_active,#{@black2},#{@yellow}}] #{pane_current_command} #[bg=terminal,fg=terminal]' \; \
  set-option pane-border-status top \; \
  set-option -pU pane-border-format
