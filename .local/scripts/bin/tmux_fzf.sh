#! /usr/bin/env bash

die() {
  echo "$*" 1>&2
  exit 1
}

if ! command -v fzf &>/dev/null; then
  die no fzf installed
fi

if [ -z "$TMUX" ]; then
  die running outside of tmux
fi

chosen=$(
  tmux list-windows -a -F '#{window_id} #{session_name}: #{window_name}' | \
    fzf --with-nth=2.. --preview="tmux capture-pane -p -e -t {1}" | \
    awk '{print $1}'
)
[ -z "$chosen" ] && exit

tmux switch-client -t "$chosen"
