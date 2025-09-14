#! /usr/bin/env bash

_SHELLS=(
  fish
  bash
  sh
  zsh
)

looks_empty() {
  for shell in "${_SHELLS[@]}"; do
    grep -iq "$shell" <<< "$1" && return 0
  done

  return 1
}
