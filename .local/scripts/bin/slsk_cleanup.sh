#! /usr/bin/env bash

die() {
  echo "$*" 1>&2
  exit 1
}

stderr() {
  echo "$*" 1>&2
}

ok() {
  tput setab 2
  tput setaf 0
  echo "$*"
  tput sgr0
}

if ! command -v metaflac &>/dev/null; then
  die metaflac required
fi

# shellcheck disable=SC2120
usage() {
  cat - <<EOF
Takes an album (FLAC) and makes sure it has at least the following metadata:
  - ARTIST
  - ALBUMARTIST
  - TRACK/TRACKNUMBER
  - TITLE
  - ALBUM

Also, adds replaygain data, a cover, and formats tracks titles.

Other stuff:
  - It removes 'SUBTITLE' tags
  - It sets ALBUMARTIST if its empty and if all the tracks have the same ARTIST

Usage:
$ slsk_cleanup.sh [<album path>]
$ slsk_cleanup.sh # uses \$PWD

Flags:
  -i|--interactive   run interactive mode to fill information if metadata is missing (only useful for fields which are the same for every song: ALBUMARTIST, ALBUM).
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

dir="."
interactive=0
while true; do
  [ -z "$1" ] && break

  case "$1" in
    --help|-h|help)
      usage
      ;;

    -i|--interactive)
      interactive=1
      ;;

    *)
      dir="$1"
      ;;
  esac

  shift
done

validate_flacs() {
  if [ -z "$(find "$dir" -type f -iname "*.flac")" ]; then
    return 1
  fi
}

# handles track/disc numbers that use the full format like this: 1/12 instead of just 1
track_or_disc_num() {
  local num="$1"
  [ -z "$num" ] && return
  if [[ "$num" =~ ^[0-9]+$ ]]; then
    echo "$num"
    return
  fi
  if [[ "$num" =~ ^[0-9]+\/[0-9]+$ ]]; then
    awk -F'/' '{print $1}'
    return
  fi
  if [[ "$num" =~ ^[0-9]+-[0-9]+$ ]]; then
    awk -F'-' '{print $1}'
    return
  fi
  stderr "[track_or_disc_num] i dont know what to do with: $num"
}

# check if track ($1) has tag ($2)
check_tag() {
  local track="$1" tag="$2"
  [ -n "$(metaflac --show-tag="$tag" "$track")" ]
}

set_tag() {
  local track="$1" tag="$2" value="$3" append="${4:-0}"
  if [ "$append" -ne 1 ]; then
    remove_tag "$track" "$tag" || return 1
  fi

  metaflac --set-tag="${tag}=${value}" "$track" || return 1
}

set_tag_all() {
  local tag="$1" value="$2" append="${4:-0}"
  if [ "$append" -ne 1 ]; then
    metaflac --remove-tag="$tag" ./*.flac || return 1
  fi

  metaflac --set-tag="${tag}=${value}" ./*.flac || return 1
}

remove_tag() {
  local track="$1" tag="$2"
  metaflac --remove-tag="$tag" "$track" || return 1
}

remove_tag_all() {
  local tag="$1"
  printf "Removing SUBTITLE tag... "
  metaflac --remove-tag="$tag" ./*.flac || return 1
  ok " Done. "
}

add_replaygain() {
  printf "Adding replagain data... "
  metaflac --add-replay-gain ./*.flac || return 1
  ok " Done. "
}

add_cover() {
  local url
  printf "Cover URL: "
  read -r url
  if [ -z "$url" ]; then
    stderr URL required
    return 1
  fi
  printf "Downloading cover... "
  curl -sS "$url" -o cover.jpg || return 1
  ok " Done. "

  printf "Setting cover... "
  metaflac --remove --block-type=PICTURE --dont-use-padding ./*.flac || return 1
  metaflac --import-picture-from=cover.jpg ./*.flac || return 1
  ok " Done. "
}

list_tracks() {
  find "$dir" -type f -iname "*.flac"
}

format_titles() {
  local num title cmds cmd track new_name disc
  declare -A names
  cmds=()
  while read -r track; do
    num="$(metaflac --show-tag=TRACK "$track" | awk -F= '{print $2}')"
    [ -z "$num" ] && num="$(metaflac --show-tag=TRACKNUMBER "$track" | awk -F= '{print $2}')"
    num="$(track_or_disc_num "$num")"
    [ -z "$num" ] && die "[format_titles] $track has no number, but it should, something is wrong"
    num="$(sed 's|^0*||' <<< "$num")" # padding causes printf to freak out
    num="$(printf '%02d' "$num")"

    title="$(metaflac --show-tag=TITLE "$track" | awk -F= '{print $2}' | sed 's|/|-|g')"
    [ -z "$title" ] && die "[format_titles] $track has no title, but it should, something is wrong"

    new_name="${num}. ${title}.flac"

    disc="$(metaflac --show-tag=DISCNUMBER "$track" | awk -F= '{print $2}')"
    [ -z "$disc" ] && disc="$(metaflac --show-tag=DISC "$track" | awk -F= '{print $2}')"
    [ -z "$disc" ] && disc=1
    disc="$(track_or_disc_num "$disc")"
    new_name="${disc} - $new_name"

    [ "$(basename "$track")" = "$new_name" ] && continue

    names["$track"]="$new_name"
    cmds+=( "mv -i \"$track\" \"$new_name\" " )
  done < <(list_tracks)

  if [ "${#cmds[@]}" -gt 0 ]; then
    for cmd in "${cmds[@]}"; do
      echo "$cmd"
    done
    printf "Continue? [N/y] "
    read -r response
    if [[ ! "${response,,}" =~ ^y(es)?$ ]]; then
      return 1
    fi

    for name in "${!names[@]}"; do
      mv -i "$name" "${names[$name]}" || return
    done
  fi
}

set_default_albumartist() {
  local tracks_count albumartist_count artist artist_tag_count response
  tracks_count=$(list_tracks | wc -l)
  albumartist_count=$(metaflac --show-tag=ALBUMARTIST ./*.flac | wc -l)
  if (( albumartist_count < tracks_count )); then
    artist=$(metaflac --show-tag=ARTIST ./*.flac | awk -F= '{print $2}' | sort | uniq)
    artist_tag_count=$(wc -l <<< "$artist")
    if [ "$artist_tag_count" -eq 1 ]; then
      printf "Setting ALBUMARTIST to %s, continue? [N/y] " "$artist"
      read -r response
      if [[ ! "${response,,}" =~ ^y(es)?$ ]]; then
        die "Please set ALBUMARTIST first, then"
      fi
      set_tag_all ALBUMARTIST "$artist"
    else
      die "Not all tracks have an ALBUMARTIST and could not infer it from ARTIST tags"
    fi
  fi
}

if ! validate_flacs; then
  die no FLACs detected
fi

if [ "$interactive" -eq 1 ]; then
  printf "ALBUMARTIST: "
  read -r response
  [ -z "$response" ] && die ALBUMARTIST required
  set_tag_all ALBUMARTIST "$response"

  printf "ALBUM: "
  read -r response
  [ -z "$response" ] && die ALBUM required
  set_tag_all ALBUM "$response"
fi

# Non-destructive stuff 
while read -r track; do
  check_tag "$track" ARTIST || die "no ARTIST in $track"
  check_tag "$track" TITLE || die "no TITLE in $track"
  check_tag "$track" ALBUM || die "no ALBUM in $track"
  if ! check_tag "$track" TRACK && ! check_tag "$track" TRACKNUMBER; then
    die "no TRACK/TRACKNUMBER in $track"
  fi

done < <(list_tracks)

# Destructive stuff
set_default_albumartist || exit
add_cover || exit
add_replaygain || exit
remove_tag_all SUBTITLE || exit
format_titles || exit
