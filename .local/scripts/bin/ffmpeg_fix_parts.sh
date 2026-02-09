#! /usr/bin/env bash

usage() {
  cat - <<EOF
Fixes broken yt-dlp .part files in a specific directory (recursively) by remuxing them.

Usage
$ ffmpeg_fix_parts.sh <dir>

Options
  -h, --help                   show this message
  -o FORMAT, --format FORMAT   specify output format (default: mp4)
  -f FILTER, --filter FILTER   find's filter (default: '*.part')
EOF
  exit 1
}

[ -z "$*" ] && usage

format="mp4"
dir=
filter="*.part"
while true; do
  [ -z "$1" ] && break

  case "$1" in
    --help|-h|help)
      usage
      ;;

    -o|--format)
      shift
      format="$1"
      ;;

    -f|--filter)
      shift
      filter="$1"
      ;;

    *)
      dir="$1"
      ;;
  esac

  shift
done

[ -z "$dir" ] && exit

commands=()
old_files=()
while read -r file; do
  fixed_file="$(sed "s|\(.*\)\..*\.part|\1\.${format}|" <<< "$file")" || exit
  if [ -f "$fixed_file" ]; then
    echo "$fixed_file already exists." >&2
    continue
  fi

  cmd="ffmpeg -i \"$file\" -c copy \"$fixed_file\""
  commands+=("$cmd")
  old_files+=("$file")
  echo "$cmd"
done < <(find "$dir" -type f -iname "$filter")

if [ "${#old_files[@]}" -lt 1 ]; then
  echo "No files matched" >&2
  exit 1
fi

printf "Continue? [N/y] "
read -r response
if [[ ! "${response,,}" =~ ^y(es)?$ ]]; then
  exit 1
fi

for cmd in "${commands[@]}"; do
  eval "$cmd" || exit
done

for file in "${old_files[@]}"; do
  echo rm "$file"
done

printf "\nRemove .part files? [N/y] "
read -r response
if [[ ! "${response,,}" =~ ^y(es)?$ ]]; then
  exit 1
fi

for file in "${old_files[@]}"; do
  rm "$file" || exit
done
