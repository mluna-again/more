#! /usr/bin/env bash

usage() {
  cat - <<EOF
Usage:
$ slsk_cleanup.sh [<path to album>]

Cleans up album.
  - checks missing metadata
  - checks naming conventions
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
album_regex='^.+ - .+$'
if [[ ! "$album" =~ $album_regex ]]; then
  echo "album doesn't match naming convention: $album" >&2
  something_wrong=1
fi

while read -r file; do
  album_name="$(metaflac --show-tag=album "$file")" || break
  album_artist="$(metaflac --show-tag=albumartist "$file")" || break
  if [ -z "$album_artist" ]; then
    album_artist="$(metaflac --show-tag=album_artist "$file")" || break
  fi
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

  title_regex='^[0-9]+ [0-9A-Za-z].+\.flac$'
  file_title="$(basename "$file")"
  if [[ ! "$file_title" =~ $title_regex ]]; then
    echo "filename doesn't match naming convention: $file_title" >&2
    something_wrong=1
  fi

  cover="$(ffprobe "$file" 2>&1 | grep 'Cover (front)')"
  if [ -z "$cover" ]; then
    if [ -f "${album}/cover.jpg" ]; then
      metaflac --import-picture-from="${album}/cover.jpg" "$file" || exit
      echo "cover added: $file"
    elif [ -f "${album}/cover.png" ]; then
      metaflac --import-picture-from="${album}/cover.png" "$file" || exit
      echo "cover added: $file"
    else
      echo "unknown/missing cover: $album" >&2
      exit 1
    fi
  fi

done < <(find "$album" -type f -iname "*.flac")

if [ "$something_wrong" -ne 0 ]; then
  exit 1
fi

metaflac --remove-replay-gain --add-replay-gain "${album}"/*.flac || exit
echo replaygain added

echo "done"
