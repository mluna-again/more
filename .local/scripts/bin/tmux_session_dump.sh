#! /usr/bin/env bash

source ~/.local/scripts/bin/tmux_util.sh || exit

name=$(tmux display -p '#{session_name}') || exit
[ -z "$name" ] && exit

cwd=$(tmux display -p '#{pane_current_path}')
path=$(tmux_ask 'Destination dir' "$cwd/")
[ -z "$path" ] && exit

if [ -d "$path" ]; then
  path="$path/${name}.yaml"
elif [[ ! "$path" =~ ^.*\.ya?ml$ ]]; then
  path="${path}.yaml"
fi
if [[ ! "$path" =~ ^/.*$ ]]; then
  path="$cwd/$path"
fi
path="$(readlink -m "$path")"

output=$(tmuxp freeze "$(tmux display -p '#{session_name}')" --yes --save-to "$path" --workspace-format yaml 2>&1)
# shellcheck disable=SC2181
if [ "$?" -ne 0 ]; then
  tmux display-popup "$output"
  exit 0
fi

tmux_info "Saved to $path"
