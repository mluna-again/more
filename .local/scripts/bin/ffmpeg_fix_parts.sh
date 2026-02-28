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
  -d DEPTH, --filter DEPTH     find's depth (default: 2)
  --force                      remux everything (default: false)
EOF
  exit 1
}

[ -z "$*" ] && usage

format="mp4"
dir=
filter="*.part"
depth="2"
force=0
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

    -d|--depth)
      shift
      depth="$1"
      ;;

    --force)
      force=1
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
files_already_fixed=()
while read -r file; do
  fixed_file="$(sed "s|\(.*\)\..*\.part|\1\.${format}|" <<< "$file")" || exit
  if [ -f "$fixed_file" ] && [ "$force" -ne 1 ]; then
    echo "$fixed_file already exists." >&2
    files_already_fixed+=("$file")
    continue
  fi

  cmd="ffmpeg -i \"$file\" -c copy -y \"$fixed_file\""
  commands+=("$cmd")
  old_files+=("$file")
  echo "$cmd"
done < <(find "$dir" -maxdepth "$depth" -type f -iname "$filter")

if [ "${#old_files[@]}" -lt 1 ]; then
  echo "No files matched" >&2
  exit 1
fi

printf "Continue? [N/y] "
read -r response
if [[ ! "${response,,}" =~ ^y(es)?$ ]]; then
  exit 1
fi

files_with_errs=()
for cmd in "${commands[@]}"; do
  if ! eval "$cmd"; then
    files_with_errs+=("$cmd")
    continue
  fi
done

if [[ "${#old_files[@]}" -gt 0 ]]; then
  files_to_delete=()
  for file in "${old_files[@]}"; do
    if echo "$files_with_errs" | grep "$file"; then
      continue
    fi
    echo rm "$file"
    files_to_delete+=("$file")
  done

  printf "\nRemove .part files? [N/y] "
  read -r response
  if [[ "${response,,}" =~ ^y(es)?$ ]]; then
    for file in "${files_to_delete[@]}"; do
      rm "$file" || exit
    done
  fi
fi

if [[ "${#files_already_fixed[@]}" -gt 0 ]]; then
  for file in "${files_already_fixed[@]}"; do
    echo rm "$file"
  done
  printf "\nRemove (probably) already fixed .part files? [N/y] "

  read -r response
  if [[ "${response,,}" =~ ^y(es)?$ ]]; then
    for file in "${files_already_fixed[@]}"; do
      rm "$file" || exit
    done
  fi
fi

if [[ "${#files_with_errs[@]}" -gt 0 ]]; then
  echo "Files with errors:"
  for file in "${files_with_errs[@]}"; do
    echo "$file"
  done
fi
