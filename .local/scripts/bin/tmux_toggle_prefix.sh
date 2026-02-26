#! /usr/bin/env bash

OPT_NAME="@forward_prefix"

is_on() {
  tmux show-option -g "$OPT_NAME" &>/dev/null
}

enable() {
  tmux set-option -g "$OPT_NAME" "#[bg=#{@red},fg=#{@black1}] FORWARDING C-b #[bg=default,fg=default]" || return
  tmux set -g prefix C-b || return
  tmux set -g status-position bottom
}

disable() {
  tmux set-option -gu "$OPT_NAME" || return
  tmux set -g prefix C-x
  tmux set -g status-position top
}

if is_on; then
  disable
else
  enable
fi
