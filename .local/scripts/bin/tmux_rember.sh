#! /usr/bin/env bash

note=$(cat ~/.cache/tmux_rember.sh 2>/dev/null)
[ -z "$note" ] && exit 0

minwidth="${1:-140}"
tw="$(tmux display -p '#{client_width}')"
styles="#[bg=#{@yellow},fg=#{@black2}]"
reset="#[bg=default,fg=default]"

if [ "$tw" -lt "$minwidth" ]; then
  echo "${styles} N* ${reset} "
  exit 0
fi

if [ "${#note}" -gt 30 ]; then
  short_note=$(cut -c 1-30 <<< "$note")
  echo "${styles} ${short_note}... ${reset} "
else
  echo "${styles} $note ${reset} "
fi
