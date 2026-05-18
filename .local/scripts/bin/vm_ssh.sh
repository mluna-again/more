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
box_one,mina,[<ssh port>],[<spice port>],[<initial program>]
box_two,lash,[<ssh port>],[<spice port>],[<initial program>]
You probably should specify both ssh and spice ports if you start multiple VMs at once, otherwise you'll get binding and ssh keyprint errors.

Usage:
$ vm_ssh.sh [<fzf-able vm name>]

Flags:
  --user USER, -u USER    user inside VM (default: $USER)
  --cmd CMD, -c CMD       initial command (default: bash)
  -p PORT, --port PORT    ssh port to connect to (default: 22220)
  -P PORT, --expose PORT  forward PORT (can be provided multiple times) (default: [])
EOF
  exit 1
}

name=
user=
initial_program=
port=
fports=()
opts=()
while true; do
  [ -z "$1" ] && break

  case "$1" in
    --help|-h|help)
      usage
      ;;

    --user|-u)
      shift
      user="$1"
      ;;

    --gui)
      opts+=( --gui )
      ;;

    -c|--cmd)
      shift
      initial_program="$1"
      ;;

    -P|--expose)
      shift
      fports+=( "$1" )
      ;;

    -p|--port)
      shift
      port="$1"
      ;;

    *)
      name="$1"
      ;;
  esac

  shift
done

vms="$(find ~/VMs -maxdepth 1 -type f -iname "*.conf")" || exit
selected="$(echo "$vms" | fzf -1 -q "$name" | head -n 1)" || exit
[ -z "$selected" ] && exit 1

vm_basename=$(basename "$selected") || exit
vm_basename="${vm_basename/.conf/}"

if [ -f ~/VMs/users ]; then
  _user=$(awk -F, "\$1 == \"$vm_basename\" { print \$2 }" ~/VMs/users)
  _port=$(awk -F, "\$1 == \"$vm_basename\" { print \$3 }" ~/VMs/users)
  _spice_port=$(awk -F, "\$1 == \"$vm_basename\" { print \$4 }" ~/VMs/users)
  _initial_program=$(awk -F, "\$1 == \"$vm_basename\" { print \$5 }" ~/VMs/users)

  if [ -z "$user" ] && [ -n "$_user" ]; then
    echo "Using $_user as user (~/VMs/users)"
    user="$_user"
  fi
  if [ -z "$initial_program" ] && [ -n "$_initial_program" ]; then
    echo "Using $_initial_program as cmd (~/VMs/users)"
    initial_program="$_initial_program"
  fi
  if [ -z "$port" ] && [ -n "$_port" ]; then
    echo "Using $_port as port (~/VMs/users)"
    opts+=( --port "$_port" )
    port="$_port"
  fi
  if [ -n "$_spice_port" ]; then
    opts+=( --spice-port "$_spice_port" )
  fi
fi

~/.local/scripts/bin/vm_start.sh "$selected" "${opts[@]}" || exit

fportopts=()
for p in "${fports[@]}"; do
  fportopts+=( -L "$p":localhost:"$p" )
done

TERM=xterm-256color ssh -t "${fportopts[@]}" -p "${port:-22220}" "${user:-$USER}"@localhost "${initial_program:-bash}"
