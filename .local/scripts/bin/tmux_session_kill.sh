#! /usr/bin/env bash

source ~/.local/scripts/bin/tmux_util.sh || exit

tmux kill-session \; switch-client -t "$(get_last_session_or_default)"
