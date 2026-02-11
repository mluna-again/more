#! /usr/bin/env bash

usage() {
  cat - <<EOF
Usage:
$ rsync_wildcard.sh <pattern> <dest>

Sends files in current directory that matches <pattern> (find pattern) to <dest> using rsync.
EOF
  exit 1
}

while true; do
  [ -z "$1" ] && break

  case "$1" in
    --help|-h|help)
      usage
      ;;

    *)
      if [ -z "$pattern" ]; then
        pattern="$1"
      else
        dest="$1"
      fi
      ;;
  esac

  shift
done

if [ -z "$pattern" ]; then
  echo "pattern empty / no matches (use quotes)" >&2
  exit 1
fi

if [ -z "$dest" ]; then
  echo "dest required" >&2
  exit 1
fi

set -x

find . -iname "$pattern" | tee rsync_wildcard_includes

rsync -avh --info=progress2 --files-from=rsync_wildcard_includes --exclude='./*' . "$dest"

rm rsync_wildcard_includes
