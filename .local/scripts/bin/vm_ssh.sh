#! /usr/bin/env bash

die() {
  echo "$*" 1>&2
  exit 1
}

usage() {
  cat - <<EOF
SSH into a quickemu VM.
Auto starts VM.
Searches for .conf files in ~/VMs.

You can create a \`users\` file in ~/VMs to specify which VMs use which users, like this:
box_one,mina
box_two,lash

Usage:
$ vm_ssh.sh [<fzf-able vm name>]

Flags:
  --user USER, -u USER    user inside VM (default: $USER)
EOF
  exit 1
}

name=
user="$USER"
while true; do
  [ -z "$1" ] && break

  case "$1" in
    --help|-h|help)
      usage
      ;;

    --user|-u)
      shift
      user="$1"
      user_specified=1
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

~/.local/scripts/bin/vm_start.sh "$selected" || exit

dir=$(dirname "$selected") || exit
vm_basename=$(basename "$selected") || exit
vm_basename="${vm_basename/.conf/}"
port=$(awk -F, '$1 == "ssh" {print $2}' "${dir}/${vm_basename}/${vm_basename}.ports" | head -n 1)
if [ -z "$port" ]; then
  die "Could not find port!"
fi

if [ -z "$user_specified" ] && [ -f ~/VMs/users ]; then
  _user=$(awk -F, "\$1 == \"$vm_basename\" { print \$2 }" ~/VMs/users)
  if [ -n "$_user" ]; then
    echo "Using $_user as user (~/VMs/users)"
    user="$_user"
  fi
fi

TERM=xterm-256color ssh -p "$port" "$user"@localhost
