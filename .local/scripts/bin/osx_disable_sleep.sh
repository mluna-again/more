#! /usr/bin/env bash

if [[ "$EUID" -ne 0 ]]; then
  echo run this as sudo >&2
  exit 1
fi

cleanup() {
  pmset -b disablesleep 0 || return
  echo sleep enabled
}
trap cleanup EXIT

pmset -b disablesleep 1 || exit
echo sleep disabled

while true; do
  sleep 100000
done
