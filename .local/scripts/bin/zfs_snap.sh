#! /usr/bin/env bash

# shellcheck disable=SC2120
usage() {
  cat - <<EOF
Usage:
$ ${0##*/} [<dataset>]

Creates a zfs snapshot for a specific dataset. Can be selected interactively with fzf.
Format used: <dataset>@\$(date +%Y-%m-%dT%H:%M:%S%z)

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

query=
while true; do
  [ -z "$1" ] && break

  case "$1" in
    --help|-h)
      usage
      ;;

    *)
      if [ -z "$query" ]; then
        query="$1"
      fi
      ;;
  esac

  shift
done

sets=()
mapfile -t sets < <(zfs list -H -o name | fzf -1 -q "$query" -m)
[ "${#sets[@]}" -lt 1 ] && exit 1

for set in "${sets[@]}"; do
  echo "$set"
done

printf "Continue? [N/y] "
read -r response
if [[ ! "${response,,}" =~ ^y(es)?$ ]]; then
  exit 1
fi


now="$(date +%Y-%m-%dT%H:%M:%S%z)"
for set in "${sets[@]}"; do
  echo zfs snap "${set}@${now}"
  sudo zfs snap "${set}@${now}" || exit
done

echo done
