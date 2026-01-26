#! /usr/bin/env bash

usage() {
  cat - <<EOF
Creates a new ZFS pool, along with a default encrypted dataset.
This creates a normal non-raid pool, because i don't have that type of money.

Usage
$ zfs_init.sh /dev/disk/by-id/<your disk>

Options
  -h, --help                 show this message
  -p NAME, --pool NAME       pool name, default: tank
  -d NAME, --dataset NAME    dataset name, default: root
  -f, --force                add -f flag to zpool create (overwrites disk data), default: false
EOF
  exit 1
}

[ -z "$*" ] && usage

disk=""
pool="tank"
dataset="root"
force=0
while true; do
  [ -z "$1" ] && break

  case "$1" in
    --help|-h|help)
      usage
      ;;

    -p|--pool)
      shift
      pool="$1"
      ;;

    -d|--dataset)
      shift
      dataset="$1"
      ;;

    -f|--force)
      force=1
      ;;

    *)
      disk="$1"
      ;;
  esac

  shift
done

[ -z "$disk" ] && exit

printf "DISK:         %s\n" "$disk"
printf "POOL NAME:    %s\n" "$pool"
printf "DATASET NAME: %s\n" "$dataset"
printf "FORCE: %d\n" "$force"
printf "Continue? [N/y] "
read -r response
if [[ ! "${response,,}" =~ ^y(es)?$ ]]; then
  exit 1
fi

set -x
if [ "$force" -eq 1 ]; then
  sudo zpool create -f "$pool" "$disk" || exit
else
  sudo zpool create "$pool" "$disk" || exit
fi
sudo zfs create -o encryption=on -o keylocation=prompt -o keyformat=passphrase "${pool}/${dataset}" || exit
sudo zpool import -a
sudo zfs list || exit
