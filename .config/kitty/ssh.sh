#! /usr/bin/env bash

export PATH="$PATH:$HOME/.local/go/bin"
if ! command -v mina &>/dev/null; then
  echo mina not installed
  read -n 1
  exit 1
fi

lsvms() {
  if command -v vm_ssh.sh &>/dev/null && [ -n "$(vm_ssh.sh --list | head -n 1)" ]; then
    vm_ssh.sh --list | sed 's|\(.*\)|[quickemu] \1|'
    grep -r -h -i "host\s" ~/.ssh/config ~/.ssh/config.d | awk '$2 != "*" {print $2}' | tr -d ' ' | sort | uniq | sed 's|\(.*\)|[alias] \1|'
  else
    grep -r -h -i "host\s" ~/.ssh/config ~/.ssh/config.d | awk '$2 != "*" {print $2}' | tr -d ' ' | sort | uniq
  fi
}

host="$(lsvms | mina -title "SSH in new tab" -icon "")"
[ -z "$host" ] && exit 1

kitten @ launch --type=tab --location=after --title="$host" ssh "$host"
