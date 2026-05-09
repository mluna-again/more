#! /usr/bin/env bash

usage() {
  cat - <<EOF
Usage:
$ rsync_wildcard.sh <pattern> [...<pattern>] <dest>

Sends files in current directory that matches <pattern> (with find's -ipath) to <dest> using rsync.

Example:
$ rsync_wildcard.sh "*themes/*" somevm:/home/user/.config/nvim                # You almost always want * at the beginning because of how find's -ipath works
$ rsync_wildcard.sh "*themes/*" "*init.lua*" somevm:/home/user/.config/nvim   # Multiple patterns

Flags
  --help | -h           show this message
  --dir DIR | -d DIR    set source directory (default: .)
EOF
  exit 1
}

patterns=()
dir="$PWD"
while true; do
  [ -z "$1" ] && break

  case "$1" in
    --help|-h|help)
      usage
      ;;

    --dir|-d)
      shift
      dir="$(readlink -m "$1")"
      ;;

    *)
      next_value="$2"
      if [ -z "$next_value" ]; then
        dest="$(readlink -m "$1")"
      else
        patterns+=( "$1" )
      fi
      ;;
  esac

  shift
done

if [ "${#patterns}" -lt 1 ]; then
  echo "at least one pattern required" >&2
  exit 1
fi

if [ -z "$dest" ]; then
  echo "dest required" >&2
  exit 1
fi

original_dir="$PWD"
cleanup() {
  rm -f rsync_wildcard_includes
  cd "$original_dir" || return
}
trap cleanup EXIT

cd "$dir" || exit

echo "∨∨∨∨∨∨∨∨∨ Files matched ∨∨∨∨∨∨∨∨∨"
echo > rsync_wildcard_includes
for pattern in "${patterns[@]}"; do
  find . -ipath "$pattern" | tee -a rsync_wildcard_includes || exit
done
echo "∧∧∧∧∧∧∧∧∧ Files matched ∧∧∧∧∧∧∧∧∧"

printf "Running: "
echo rsync -avhbu --info=progress2 --files-from=rsync_wildcard_includes --exclude='./*' "$dir" "$dest"
printf "Continue? [N/y] "
read -r response
if [[ ! "${response,,}" =~ ^y(es)?$ ]]; then
  exit 1
fi

rsync -avhbu --info=progress2 --files-from=rsync_wildcard_includes --exclude='./*' "$dir" "$dest"

