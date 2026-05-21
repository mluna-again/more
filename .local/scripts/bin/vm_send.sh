#! /usr/bin/env bash

die() {
  echo "$*" 1>&2
  exit 1
}

# shellcheck disable=SC2120
usage() {
  cat - <<EOF
Sends a file to a VM in ~/VMs.
Displays a preview of the diff if the file already exists on the other side.
Uses \`delta\` if available, or \`diff\`.

This script is meant for single files only, mainly for specific config files I wanna copy into a VM. For general file transfer use rsync.

Usage:
$ ${0##*/} <fzf-able vm name> <src> <dest>

Flags:
  --help | -h      show this message
EOF
  if [ "$#" -gt 0 ]; then
    echo
    tput setab 1
    tput setaf 0
    printf " ERROR "
    tput sgr0
    echo " $*"
  fi
  exit 1
}

vm=
src=
dest=
while true; do
  [ -z "$1" ] && break

  case "$1" in
    --help|-h)
      usage
      ;;

    *)
      if [ -z "$vm" ]; then
        vm="$(find ~/VMs -maxdepth 1 -type f -iname '*.conf' | fzf +m -1 -q "$1" | head -n 1)"
        [ -z "$vm" ] && exit 1
      else
        if [ -z "$src" ]; then
          if [ ! -f "$1" ] && [ ! -d "$1" ]; then
            usage "$1 is not a file or directory"
          fi
          src="$1"
        elif [ -z "$dest" ]; then
          dest="$1"
        else
          usage too many arguments
        fi
      fi
      ;;
  esac

  shift
done

[ -z "$vm" ] && usage vm required
[ -z "$src" ] && usage no source file
[ -z "$dest" ] && usage no dest file

vmname="$(basename "$vm" .conf)"
if ! grep -qE "Host\s+$vmname" ~/.ssh/config; then
  die "$vmname has not an SSH alias yet, use vm_alias.sh <vm> first"
fi

dest_copy="$(mktemp /tmp/vm_send.XXXXXXXX)" || exit
cleanup() {
  rm "$dest_copy"
}
trap cleanup EXIT

echo "fetching current version..."
if rsync -ah "$vmname":"$dest" "$dest_copy" &>/dev/null; then
  diff=
  if command -v delta &>/dev/null; then
    delta --side-by-side --paging=never "$src" "$dest_copy"
    diff="$?"
  else
    diff --color=always --unified --suppress-common-lines "$src" "$dest_copy"
    diff="$?"
  fi
  if [ "$diff" -eq 0 ]; then
    echo "$src (as $dest) already in $vmname"
    exit 0
  fi
  printf "continue? [N/y] "
  read -r response
  if [[ ! "${response,,}" =~ ^y(es)?$ ]]; then
    exit 1
  fi
else
  echo "no current version found"
fi

rsync -ahq "$src" "$vmname":"$dest" || exit

echo "done :D"
