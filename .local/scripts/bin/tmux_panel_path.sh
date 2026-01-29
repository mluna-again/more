#! /usr/bin/env bash

tmux set-option pane-border-format '#[bg=#{?pane_active,#{@yellow},#{@black2}},fg=#{?pane_active,#{@black2},#{@yellow}}] #{pane_current_path} #[bg=terminal,fg=terminal]' \; set-option pane-border-status top
