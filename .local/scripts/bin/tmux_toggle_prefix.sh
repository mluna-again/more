#! /usr/bin/env bash

OPT_NAME="@forward_prefix"

originalprefix="C-x"
prefix2="C-b"
is_on() {
  tmux show-option "$OPT_NAME" &>/dev/null
}

enable() {
  tmux set-option "$OPT_NAME" "#[bg=#{@red},fg=#{@black1}] ${originalprefix} -> ${prefix2} #[bg=default,fg=default]" || return
  tmux set prefix "$prefix2" || return
  tmux set status-position bottom
}

disable() {
  tmux set-option -u "$OPT_NAME" || return
  tmux set prefix "$originalprefix"
  tmux set status-position top
}

if is_on; then
  disable
else
  enable
fi
