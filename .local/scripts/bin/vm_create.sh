#! /usr/bin/env bash

usage() {
  cat - <<EOF
Creates VMs with quickget and quickemu.
Last time I checked it was a mess to create a VM with a custom name, so I made this script.

Usage:
$ vm_create.sh <vm name> [<os>] [<release>] [<version>]
If you want to omit the release/version use a " ", *not* an empty string, a quoted space.

Defaults:
  os: fedora
  release: 43
  version: Workstation
EOF
  exit 1
}

name=
os=
release=
version=
while true; do
  [ -z "$1" ] && break

  case "$1" in
    --help|-h|help)
      usage
      ;;

    *)
      if [ -z "$name" ]; then
        name="$1"
      elif [ -z "$os" ]; then
        os="$1"
      elif [ -z "$release" ]; then
        release="$1"
      elif [ -z "$version" ]; then
        version="$1"
      else
        usage
      fi
      ;;
  esac

  shift
done

os="${os:-fedora}"
release="${release:-43}"
version="${version:-Workstation}"

[ -z "$name" ] && usage

cwd="$PWD"
download_dir=$(mktemp --directory) || exit
cleanup() {
  rm -rf "$download_dir"
}
trap cleanup EXIT

cd "$download_dir" || exit
download_cmd="quickget --download \"$os\" \"$release\" \"$version\""
echo "Dest: $cwd"
echo "Tmp dir: $download_dir"
echo "$download_cmd"
printf "Continue? [N/y] "
read -r response
if [[ ! "${response,,}" =~ ^y(es)?$ ]]; then
  exit 1
fi

eval "$download_cmd" || exit

cd "$cwd" || exit
mv "$download_dir"/*.iso . || exit

quickget --create-config "$name" ./*.iso || exit
