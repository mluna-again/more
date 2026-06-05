#! /usr/bin/env bash

cleanup() {
  rm ~/.cache/tmux_cmd.sh.selected
}
trap cleanup EXIT

value="$(cat ~/.cache/tmux_cmd.sh.selected | head -n 1)"
[ -z "$value" ] && exit 0

tmux command-prompt -I "$value"
true
