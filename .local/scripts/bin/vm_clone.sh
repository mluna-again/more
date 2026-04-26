#! /usr/bin/env bash

VMS="$HOME/VMs"

die() {
  echo "$*" 1>&2
  exit 1
}

usage() {
  cat - <<EOF
Clones an existing Quickemu VM into ~/VMs.

Usage:
$ vm_clone.sh <fzf-able vm name> <new vm name>
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

vm=""
newvm=""
while true; do
  [ -z "$1" ] && break

  case "$1" in
    --help|-h|help)
      usage
      ;;

    *)
      if [ -z "$vm" ]; then
        vm="$(find ~/VMs -maxdepth 1 -mindepth 1 -type f -exec basename {} \; | fzf -1 -q "$1")" || exit
        vm="$(basename "$vm" .conf)" || exit
      else
        newvm="$1"
      fi
      ;;
  esac

  shift
done

[ -z "$vm" ] && usage vm name required
[ -z "$newvm" ] && usage new vm name required

if [ -f "${VMS}/${newvm}.conf" ] || [ -d "${VMS}/$newvm" ]; then
  die "$newvm already exists"
fi

echo "$vm -> $newvm"
printf "Continue? [N/y] "
read -r response
if [[ ! "${response,,}" =~ ^y(es)?$ ]]; then
  exit 1
fi

if pgrep -i "$vm"; then
  printf "It looks like %s is currently running, stop it? [N/y] " "$vm"
  read -r response
  if [[ ! "${response,,}" =~ ^y(es)?$ ]]; then
    exit 1
  fi
  ~/.local/scripts/bin/vm_kill.sh "$vm" || exit
fi

echo "Making new VM directory..."
mkdir "${VMS}/$newvm" || exit
echo "Copying files..."
cp "${VMS}/${vm}/disk.qcow2" "${VMS}/${newvm}" || exit
cp "${VMS}/${vm}/OVMF_VARS.qcow2" "${VMS}/${newvm}" || exit
cp "${VMS}/${vm}/"*.iso "${VMS}/${newvm}" || exit # I know you can share the iso but whatever

cp "${VMS}/${vm}.conf" "${VMS}/${newvm}.conf" || exit
sed -i "s|$vm|$newvm|g" "${VMS}/${newvm}.conf" || exit

echo "Done."

