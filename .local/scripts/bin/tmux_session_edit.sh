#! /usr/bin/env bash

source ~/.local/scripts/bin/tmux_util.sh || exit

BASE_DIR="$HOME/.local/tmuxp"

current="$(tmux display -p '#{session_name}')"
session_path="${BASE_DIR}/${current}.yaml"
if ! [ -f "$session_path" ]; then
  tmux_alert "No ${current}.yaml file found in $BASE_DIR"
  exit 0
fi

tmux display-popup -EE -y S -x 0 -w 100% -h "$(client_height_no_bar)" "nvim $session_path"
