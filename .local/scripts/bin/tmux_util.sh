#! /usr/bin/env bash

_SHELLS=(
  fish
  bash
  sh
  zsh
)

tmux_ask() {
  tmux command-prompt -p "$1" 'display -p %%'
}

looks_empty() {
  for shell in "${_SHELLS[@]}"; do
    grep -iq "$shell" <<< "$1" && return 0
  done

  return 1
}
