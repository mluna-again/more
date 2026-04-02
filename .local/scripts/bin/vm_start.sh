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
  --gui                  opens a gtk gui.
  --port PORT, -p PORT   SSH port
  --spice-port PORT      SPICE port
EOF
  exit 1
}

vm=
gui=0
port=
spice_port=
while true; do
  [ -z "$1" ] && break

  case "$1" in
    --help|-h|help)
      usage
      ;;

    --gui)
      gui=1
      ;;

    --port|-p)
      shift
      port="$1"
      ;;

    --spice-port)
      shift
      spice_port="$1"
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

if [ -n "$port" ]; then
  opts+=( --ssh-port "$port" )
fi

if [ -n "$spice_port" ]; then
  opts+=( --spice-port "$spice_port" )
fi

quickemu --vm "$vm" "${opts[@]}"

vm_basename=$(basename "$vm")
dir="${vm/.conf/}"
echo
echo "PORTS"
awk -F, '{printf "%s: %s\n", $1, $2}' "${dir}/${vm_basename/.conf/}.ports"
