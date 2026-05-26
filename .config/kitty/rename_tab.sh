#! /usr/bin/env bash

basic() {
  local name
  printf "[WARN]: mina/jq missing\n"
  printf "Rename kitty tab: "
  read -r name
  [ -z "$name" ] && return

  kitten @ set-tab-title "$name"
}

cool() {
  local current name
  current="$(kitten @ ls --self --match-tab state:focused | jq -r '.[0].tabs[0].title')"

  name="$(mina -title "Rename kitty tab" -mode prompt -icon "" -default "$current")"
  [ -z "$name" ] && return

  kitten @ set-tab-title "$name"
}

export PATH="$PATH:$HOME/.local/go/bin"
if command -v mina &>/dev/null && command -v jq &>/dev/null; then
  cool
else
  basic
fi
