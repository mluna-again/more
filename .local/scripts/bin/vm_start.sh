#! /usr/bin/env bash

die() {
  echo "$*" 1>&2
  exit 1
}

usage() {
  cat - <<EOF
Just a convenience script.
Start a quickemu VM.
It starts it in headless mode by default.

Usage:
$ vm_start.sh <.conf file>

Flags:
  --gui   opens a gtk gui.
EOF
  exit 1
}

vm=
gui=0
while true; do
  [ -z "$1" ] && break

  case "$1" in
    --help|-h|help)
      usage
      ;;

    --gui)
      gui=1
      ;;

    *)
      vm="$1"
      ;;
  esac

  shift
done

[ -z "$vm" ] && usage

opts=()
if [ "$gui" -eq 1 ]; then
  opts+=( --display gtk )
else
  opts+=( --display none )
fi

quickemu --vm "$vm" "${opts[@]}"

vm_basename=$(basename "$vm")
dir="${vm/.conf/}"
echo
echo "PORTS"
awk -F, '{printf "%s: %s\n", $1, $2}' "${dir}/${vm_basename/.conf/}.ports"
