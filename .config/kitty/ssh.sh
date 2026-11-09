#! /usr/bin/env bash

cleanup() {
  kitten @ action goto_layout splits
}
trap cleanup EXIT

export PATH="$PATH:$HOME/.local/go/bin"
if ! command -v mina &>/dev/null; then
  echo mina not installed
  read -n 1
  exit 1
fi

lsvms() {
  grep -r -h -i "host\s" ~/.ssh/config ~/.ssh/config.d | awk '$2 != "*" {print $2}' | tr -d ' ' | sort | uniq
}

host="$(lsvms | mina -title "SSH in new tab" -icon "")"
[ -z "$host" ] && exit 1

if [ -f ~/VMs/"$host".conf ] && ! ssh "$host" -o RemoteCommand='echo ok' &>/dev/null; then
  if ! vm_start.sh "$host"; then
    echo "Press any key to continue."
    read -n 1
    exit 1
  fi
  sleep 3
fi

kitten @ launch --type=tab --location=after --title="$host" ssh "$host"
