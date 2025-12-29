#! /usr/bin/env bash

result=$(
  niri msg --json outputs | jq -r '.|to_entries[].value | "\(.name) \(.current_mode) \(.make)"' | \
    awk '{if ($2 == "null") {state = "OFF"} else {state = "ON"}; $2 = state; print $0}' | \
    wofi --show dmenu --insensitive
) || exit
[ -z "$result" ] && exit

display=$(awk '{print $1}' <<< "$result")
state=$(awk '{print tolower($2)}' <<< "$result")
if [ "$state" = on ]; then
  state=off
else
  state=on
fi

niri msg output "$display" "$state"
