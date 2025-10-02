#! /usr/bin/env bash

_SHELLS=(
  fish
  bash
  sh
  zsh
)

tmux_menu() {
  local title
  title="$1"
  shift

  tmux display-popup -h 17 -w 40 -y 15% -EE sh -c "printf \"%s\n\" \"$*\" | mina -sep @ -title \"$title\" -mode menu >~/.cache/mina_response"
  cat ~/.cache/mina_response
}

tmux_ask() {
  tmux display-popup -h 3 -B -y 5% -EE sh -c "mina --title=\"$1\" --icon=\"$2\" --mode prompt >~/.cache/mina_response"
  cat ~/.cache/mina_response
}

tmux_prompt() {
  tmux display-popup -h 1 -w 100% -B -y 0 -EE sh -c "mina --title=\"$1\" --mode confirm >~/.cache/mina_response"
  cat ~/.cache/mina_response
}

looks_empty() {
  for shell in "${_SHELLS[@]}"; do
    grep -iq "$shell" <<< "$1" && return 0
  done

  return 1
}
