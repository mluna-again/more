#! /usr/bin/env bash

die() {
  echo "$*" 1>&2
  exit 1
}

usage() {
  cat - <<EOF
Kills a running VM.
Searches for .conf files in ~/VMs.

Usage:
$ vm_kill.sh [<fzf-able vm name>]
EOF
  exit 1
}

name=
while true; do
  [ -z "$1" ] && break

  case "$1" in
    --help|-h|help)
      usage
      ;;

    *)
      name="$1"
      ;;
  esac

  shift
done

vms=$(find ~/VMs -maxdepth 1 -type f -iname "*.conf") || exit
selected=$(echo "$vms" | fzf -1 -q "$name" | head -n 1) || exit
[ -z "$selected" ] && exit 1

quickemu --vm "$selected" --kill
