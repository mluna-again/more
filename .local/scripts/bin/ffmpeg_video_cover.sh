#! /usr/bin/env bash

# shellcheck disable=SC2120
usage() {
  cat - <<EOF
Usage:
$ ${0##*/} <video> <cover>

Add cover to a video.
<cover> can be a link.

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

maybe_download_cover() {
  local tmpcover tmpcover_out ua
  ua="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36"

  if [ -f "$cover" ]; then
    return 0
  fi

  if [[ "$cover" =~ ^http.*$ ]]; then
    tmpcover="$(mktemp /tmp/ffmpeg_video_cover.XXXXXX)" || return 1
    printf "Downloading cover... "
    if curl -A "$ua" -H 'Accept-Language: en' -fSs -L "$cover" -o "$tmpcover"; then
      tmpcover_out="$(basename "$tmpcover")"
      tmpcover_out="${tmpcover_out}.jpg"
      magick -format jpg "$tmpcover" "$tmpcover_out" || return 1
      rm -f "$tmpcover"
      cover="$tmpcover_out"
      echo "OK."
      delete_cover=1
    else
      return 1
    fi
  fi
}

delete_cover=
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
        maybe_download_cover || exit
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

extension="${video##*.}"
out="$(mktemp "ffmpeg_video_cover.XXXXXXX.${extension}")" || exit
cleanup() {
  if [ -z "$done" ]; then
    printf "Restoring backup... "
    if mv "$video_backup" "$video"; then
      echo "OK."
    else
      return
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

  if [ -n "$delete_cover" ]; then
    rm -f "$cover"
  fi
}
trap cleanup EXIT

original_hash=
new_hash=

mv "$video" "$video_backup" || exit
if ! original_hash="$(ffmpeg -i "$video_backup" -map 0:V -c copy -f md5 - 2>/dev/null)"; then
  echo "Could not calculate original md5 hash" >&2
  exit 1
fi

ffmpeg -y -i "$video_backup" -i "$cover" -map 1 -map 0:V -c copy -disposition:0 attached_pic "$out" || exit
cp "$out" "$video" || exit
if ! new_hash="$(ffmpeg -i "$out" -map 0:V -c copy -f md5 - 2>/dev/null)"; then
  echo "Could not calculate new md5 hash" >&2
  exit 1
fi

echo "Original video hash: $original_hash"
echo "New video hash: $new_hash"
if [[ "$original_hash" != "$new_hash" ]]; then
  echo "Hashes don't match, aborting." >&2
  exit 1
else
  echo "Hashes match!"
fi

done=1
