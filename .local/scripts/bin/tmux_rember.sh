#! /usr/bin/env bash

note=$(cat ~/.cache/tmux_rember.sh 2>/dev/null)
[ -z "$note" ] && exit 0

if [ "${#note}" -gt 30 ]; then
  short_note=$(cut -c 1-30 <<< "$note")
  echo " ${short_note}... "
else
  echo " $note "
fi
