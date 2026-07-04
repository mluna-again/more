#! /usr/bin/env bash

# shellcheck disable=SC2120
usage() {
  cat - <<EOF
Usage:
$ ${0##*/} <video> <cover>

Add cover to a video.

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

video=
cover=
while true; do
  [ -z "$1" ] && break

  case "$1" in
    --help|-h)
      usage
      ;;

    *)
      if [ -z "$video" ]; then
        video="$1"
      elif [ -z "$cover" ]; then
        cover="$1"
      fi
  esac

  shift
done

[ -z "$video" ] && usage Missing video
[ -z "$cover" ] && usage Missing cover
[ -f "$video" ] || usage Video: ENOENT
[ -f "$cover" ] || usage Cover: ENOENT

done=
video_backup="${video}.bak"

out="$(mktemp /tmp/ffmpeg_video_cover.XXXXXXX.mp4)" || exit
cleanup() {
  if [ -z "$done" ]; then
    printf "Restoring backup... "
    if mv "$video_backup" "$video"; then
      echo "OK."
    fi
  else
    printf "Removing backup... "
    if rm -f "$video_backup"; then
      echo "OK."
    fi
  fi

  printf "Removing %s... " "$out"
  if rm -f "$out"; then
    echo "OK."
  fi
}
trap cleanup EXIT

mv "$video" "$video_backup" || exit
ffmpeg -y -i "$video_backup" -i "$cover" -map 1 -map 0 -c copy -disposition:0 attached_pic "$out" || exit
cp "$out" "$video" || exit
done=1
