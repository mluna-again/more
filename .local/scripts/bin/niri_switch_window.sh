#! /usr/bin/env bash

window_id=$(
  niri msg --json windows | \
  jq -r '. | map({id: .id, title: .title, app: .app_id}) | map("\(.id)@@@@@\(.app)@@@@@\(.title)") | .[]' | \
  awk -F@@@@@ '{n=split($2, name, "."); if (index(tolower($3), tolower(name[n]))) {print $1, $3} else {print $1, name[n], $3}}' | \
  wofi --show dmenu --matching fuzzy --insensitive | \
  awk '{print $1}'
) || exit
[ -z "$window_id" ] && exit

niri msg action focus-window --id "$window_id"
