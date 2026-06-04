#! /usr/bin/env bash

if ! command -v mina &>/dev/null; then
  exit 0
fi

cleanup() {
  [ -n "$selected" ] && return
  rm ~/.cache/tmux_cmd.sh.selected &>/dev/null
}
trap cleanup EXIT

selected="$(
  {
    tmux list-commands -F '#{command_list_name} #{command_list_usage}' ;
    tmux show-option -gv command-alias | awk -F= '{printf "%s (alias: %s)\n", $1, $2}' ;
  } | \
  mina -nobanner -icon ":" | \
  head -n 1 | \
  awk '{ if ($0 ~ /\(alias: /) { sub(/.*\(alias: /, ""); sub(/\)$/, ""); print $0 } else { print $1 } }'
)"
[ -z "$selected" ] && exit 0

echo "$selected" > ~/.cache/tmux_cmd.sh.selected || exit
selected=1
