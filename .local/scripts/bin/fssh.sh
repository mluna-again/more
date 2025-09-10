#! /usr/bin/env bash

host=$(awk '$1 == "Host" {print $2}' ~/.ssh/config | grep -vF '*' | fzf -1) || exit
[ -z "$host" ] && exit 1

ssh "$host"
