#! /usr/bin/env bash

usage() {
  cat - <<EOF
Just a convenience script.
Start a quickemu VM.

Usage:
$ vm_start.sh <.conf file>
EOF
  exit 1
}

vm=
while true; do
  [ -z "$1" ] && break

  case "$1" in
    --help|-h|help)
      usage
      ;;

    *)
      vm="$1"
      ;;
  esac

  shift
done

[ -z "$vm" ] && usage

quickemu --vm "$vm"

dir="${vm/.conf/}"
echo
echo "PORTS"
awk -F, '{printf "%s: %s\n", $1, $2}' "${dir}/${dir}.ports"
