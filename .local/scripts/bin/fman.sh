#! /usr/bin/env bash

query="$1"
[ -z "$query" ] && exit 1

result=$(apropos "$query" | fzf -1 | awk '{printf "%s %s", $1, $2}')
[ -z "$result" ] && exit 1

read -r name section <<< "$result" || exit

section=$(sed 's|[\(\)]||g' <<< "$section") || exit

man "$section" "$name"
