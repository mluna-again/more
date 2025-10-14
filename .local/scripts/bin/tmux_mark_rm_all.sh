#! /usr/bin/env bash

source ~/.local/scripts/bin/tmux_util.sh || exit

STATE="$HOME/.local/share/tmux_marks"

unmark_all "$STATE" || exit

: > "$STATE"
