#! /usr/bin/env bash

tmux set-option -w pane-border-format '#[bg=#{?pane_active,#{@yellow},#{@black2}},fg=#{?pane_active,#{@black2},#{@yellow}}] #{?#{>:#{w:@pane_message},0},#{@pane_message},No message} #[bg=terminal,fg=terminal]' \; set-option pane-border-status top
