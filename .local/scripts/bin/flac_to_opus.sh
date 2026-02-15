#! /usr/bin/env bash

usage() {
  cat - <<EOF
Usage:
$ flac_to_opus.sh <src library> <dest library>
$ flac_to_opus.sh ~/Music ~/Opus # default values

Converts your library of FLACs to Opus.

Flags:
  --today    only look up files whose mtime is less than 24hrs. faster but may miss some files.
  --force    re-encode files even if they already exist

Dependencies:
  * opusenc
EOF
  exit 1
}

src=~/Music
dest=~/Opus
today=0
force=0
while true; do
  [ -z "$1" ] && break

  case "$1" in
    --help|-h|help)
      usage
      ;;

    --today)
      today=1
      ;;
    --force)
      force=1
      ;;

    *)
      if [ -z "$src" ]; then
        src="$1"
      else
        dest="$1"
      fi
      ;;
  esac

  shift
done

[ -z "$src" ] && usage
[ -z "$dest" ] && usage

replicate_dirs() {
  local src="$1" dest="$2"

  while read -r dir; do
    mkdir --parents "$dir" || exit
  done < <(find "$src" -mindepth 1 -type d -printf "$dest/%P\n")
}

copy_files() {
  local src="$1" dest="$2"

  cmd="find \"$src\" -type f -printf \"%P\n\""
  if [ "$today" -eq 1 ]; then
    cmd="find \"$src\" -type f -mtime -1 -printf \"%P\n\""
  fi

  total="$(eval "$cmd" | grep -E '\.flac$' | wc -l)"
  count=0

  while read -r file; do
    [ "$file" = spotless.db ] && continue
    srcpath="$src/$file"
    destpath="$dest/$file"
    destpath="$(sed 's|.flac$|.opus|' <<< "$destpath")"

    case "$file" in
      *.flac)
        tput cuu 1
        tput el
        echo -e "\e[1A\e[K[${count}/${total}] $destpath"

        if [ -f "$destpath" ] && [ "$force" -ne 1 ]; then
          count=$(( count + 1 ))
          continue
        fi

        if ! opusenc --bitrate 192 --quiet "$srcpath" "$destpath"; then
          rm "$destpath"
          return 1
        fi
        touch --reference "$srcpath" "$destpath" || return 1
        count=$(( count + 1 ))
        ;;

      *)
        cp "$srcpath" "$destpath" || return 1
        touch --reference "$srcpath" "$destpath" || return 1
        ;;
    esac
  done < <(eval "$cmd")
}

replicate_dirs "$src" "$dest"
copy_files "$src" "$dest"

echo "done"
