#! /usr/bin/env bash

# shellcheck disable=SC2120
usage() {
  cat - <<EOF
Resizes an image to fit a steam cover (ignores aspect ratio because funny).

Usage:
$ steam_cover.sh <your image>

Flags:
  --help | -h   show this message
  --ratio       preserve aspect ratio if you are lame
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

image=""
new_name=""
height="1240"
while true; do
  [ -z "$1" ] && break

  case "$1" in
    --help|-h|help)
      usage
      ;;

    --ratio)
      height="-1"
      ;;

    *)
      image="$1"
      new_name="${image%.*}_cover.jpg"
      ;;
  esac

  shift
done

[ -z "$image" ] && usage image required
[ ! -f "$image" ] && usage "could not open $image"

ffmpeg -i "$image" -vf scale=3840:"$height" -frames:v 1 "$new_name"
