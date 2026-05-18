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
$ vm_start.sh <fzf-able vm name>

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
      vm="$(find ~/VMs -maxdepth 1 -type f -iname '*.conf' | fzf -1 -q "$1" | head -n 1)"
      [ -z "$vm" ] && exit 1
      ;;
  esac

  shift
done

[ -z "$vm" ] && usage
if [ ! -f "$vm" ]; then
  echo "No config file named $vm found"
  exit 1
fi

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

vm_name="$(basename "$vm")"
vm_name="${vm_name/.conf/}"
if pgrep -fl "qemu-system.*$vm_name" &>/dev/null; then
  if [ "$gui" -eq 1 ]; then
    # https://github.com/quickemu-project/quickemu/issues/234 virt-manager would have been a good alternative, but oh well
    printf "%s is already running but you specified --gui, do you want to restart it to enable --gui? [N/y] " "$vm_name"
    read -r response
    if [[ ! "${response,,}" =~ ^y(es)?$ ]]; then
      exit 1
    fi
    ~/.local/scripts/bin/vm_kill.sh "${vm_name}.conf"
  else
    echo "$vm_name already running."
    exit 0
  fi
fi

quickemu --vm "$vm" "${opts[@]}" --extra_args --daemonize

dir="${vm/.conf/}"
ports_file="${dir}/${vm_name}.ports"
if [ ! -f "$ports_file" ]; then
  echo "looks like $vm didnt't start"
  exit 1
fi
echo
echo "PORTS"
awk -F, '{printf "%s: %s\n", $1, $2}' "${dir}/${vm_name}.ports"
