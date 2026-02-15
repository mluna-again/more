#! /usr/bin/env bash

usage() {
  cat - <<EOF
Usage:
$ slsk_cleanup.sh [<path to album>]

Cleans up album.
  - checks missing metadata
  - adds replaygain values
  - embeds cover (if present)
EOF
  exit 1
}

album="$PWD"
while true; do
  [ -z "$1" ] && break

  case "$1" in
    --help|-h|help)
      usage
      ;;

    *)
      album="$1"
      ;;
  esac

  shift
done

[ -z "$album" ] && usage
if [ ! -d "$album" ]; then
  echo "$album is not a directory / is not accessible" >&2
  exit 1
fi

something_wrong=0
while read -r file; do
  album_name="$(metaflac --show-tag=album "$file")" || break
  album_artist="$(metaflac --show-tag=albumartist "$file")" || break
  [ -z "$album_artist" ] && album_artist="$(metaflac --show-tag=album_artist "$file")" || break
  title="$(metaflac --show-tag=title "$file")" || break

  if [ -z "$album_name" ]; then
    echo "missing album title: $file" >&2
    something_wrong=1
  fi

  if [ -z "$album_artist" ]; then
    echo "missing album artist: $file" >&2
    something_wrong=1
  fi

  if [ -z "$title" ]; then
    echo "missing track title: $file" >&2
    something_wrong=1
  fi
done < <(find "$album" -type f -iname "*.flac")

if [ "$something_wrong" -ne 0 ]; then
  exit 1
fi

metaflac --add-replay-gain "${album}"/*.flac || exit

if [ -f "${album}/cover.jpg" ]; then
  metaflac --import-picture-from="${album}/cover.jpg" "${album}"/*.flac || exit
elif [ -f "${album}/cover.png" ]; then
  metaflac --import-picture-from="${album}/cover.png" "${album}"/*.flac || exit
else
  cover="$(ffprobe "$file" 2>&1 | grep 'Cover (front)')"
  if [ -z "$cover" ]; then
    echo "unknown/missing cover: $album" >&2
    exit 1
  fi
fi

echo done
