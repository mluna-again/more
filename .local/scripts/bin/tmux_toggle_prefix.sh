#! /usr/bin/env bash

OPT_NAME="@forward_prefix"

prefix=$(tmux show-options -gv prefix)
is_on() {
  tmux show-option "$OPT_NAME" &>/dev/null
}

enable() {
  tmux set-option "$OPT_NAME" "#[bg=#{@red},fg=#{@black1}] FORWARDING ${prefix} #[bg=default,fg=default]" || return
  tmux set prefix C-b || return
  tmux set status-position bottom
}

disable() {
  tmux set-option -u "$OPT_NAME" || return
  tmux set prefix C-x
  tmux set status-position top
}

if is_on; then
  disable
else
  enable
fi
