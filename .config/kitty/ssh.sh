#! /usr/bin/env bash

export PATH="$PATH:$HOME/.local/go/bin"
if ! command -v mina &>/dev/null; then
  echo mina not installed
  read -n 1
  exit 1
fi

host="$(grep -r -h -i "host\s" ~/.ssh/config ~/.ssh/config.d | awk '$2 != "*" {print $2}' | tr -d ' ' | mina -title "SSH in new tab" -icon "")"
[ -z "$host" ] && exit 1

kitten @ launch --type=tab --location=after --title="$host" ssh "$host"
