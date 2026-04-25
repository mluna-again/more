#! /usr/bin/env bash

die() {
  echo "$*" 1>&2
  exit 1
}

usage() {
  cat - <<EOF
Adds an alias entry to ~/.ssh/config for the given VM.
Honors \`users\` file.

Usage:
$ vm_alias.sh <fzf-able vm name>
EOF
  exit 1
}

vm=""
while true; do
  [ -z "$1" ] && break

  case "$1" in
    --help|-h|help)
      usage
      ;;
      
    *)
      vm="$(find ~/VMs -maxdepth 1 -mindepth 1 -type f -exec basename {} \; | fzf -1 -q "$1")" || exit
      vm="$(basename "$vm" .conf)" || exit
      ;;
  esac

  shift
done

if [ -z "$vm" ]; then
  die vm required
fi

if grep -Eiq "Host\s+$vm" ~/.ssh/config; then
  die "entry for $vm already exists"
fi

_user=$(awk -F, "\$1 == \"$vm\" { print \$2 }" ~/VMs/users)
_port=$(awk -F, "\$1 == \"$vm\" { print \$3 }" ~/VMs/users)

cat - <<EOF | tee -a ~/.ssh/config
Host $vm
  Hostname localhost
  Port ${_port:-22220}
  User ${_user:-user}
EOF
