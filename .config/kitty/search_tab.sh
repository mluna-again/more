#! /usr/bin/env bash

export PATH="$PATH:$HOME/.local/go/bin"
if command -v mina &>/dev/null && command -v jq &>/dev/null; then
  selected="$(kitten @ ls | jq -r '.[0].tabs[] | "\(.id) \(.title)"' | mina -nth 1 -title "Search KITTY tab" -icon "" | awk '{print $1}')"
  [ -z "$selected" ] && return

  kitten @ focus-tab --match id:"$selected"
else
  printf "[WARN]: mina/jq missing\n"
  printf "Press any key to exit."
  read -N 1
fi
