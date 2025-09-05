#! /usr/bin/env bash

proc=$(ps a --no-headers --format 'ruser pid args' | fzf -1 | awk '{print $2}') || exit
[ -z "$proc" ] && exit 1

echo "$proc"
