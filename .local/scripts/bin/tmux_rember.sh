#! /usr/bin/env bash

note=$(cat ~/.cache/tmux_rember.sh 2>/dev/null)
[ -z "$note" ] && exit 0

minwidth="${1:-140}"
tw="$(tmux display -p '#{client_width}')"

if [ "$tw" -lt "$minwidth" ]; then
  echo " N* "
  exit 0
fi

if [ "${#note}" -gt 30 ]; then
  short_note=$(cut -c 1-30 <<< "$note")
  echo " ${short_note}... "
else
  echo " $note "
fi
