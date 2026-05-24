#! /usr/bin/env bash

# shellcheck disable=SC2120
usage() {
  cat - <<EOF
Wrapper around yazi --chooser-file=<file> --cwd-file=<file>, handles exit appropriately.
If nothing is selected prints nothing, if something is selected prints two lines:
  - selected file
  - current directory

Usage:
$ ${0##*/} [...<path>]

Flags:
  --help | -h      show this message
  -E | --empty     print empty lines ("") instead of nothing when no file is selected
  -X | --xline     prints empty line before results (useful when using a subshell + /dev/tty to avoid gibberish)
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

dir=()
print_empty=
extra_line=
while true; do
  [ -z "$1" ] && break

  case "$1" in
    --help|-h)
      usage
      ;;

    -E|--empty)
      print_empty=1
      ;;

    -X|--xline)
      extra_line=1
      ;;

    *)
      dir+=( "$1" )
      ;;
  esac

  shift
done

chooser_file="$(mktemp /tmp/yazi_pick.XXXXX)" || exit
cwd_file="$(mktemp /tmp/yazi_pick.XXXXX)" || exit
cleanup() {
  rm "$chooser_file"
  rm "$cwd_file"
}
trap cleanup EXIT

_dir=( "${dir[@]}" )
if [ -z "${dir[*]}" ]; then
  _dir=( "$PWD" )
fi
yazi "${_dir[@]}" --chooser-file="$chooser_file" --cwd-file="$cwd_file"

file="$(cat "$chooser_file" | head -n1)"
if [ -z "$file" ]; then
  [ -n "$extra_line" ] && echo
  [ -z "$print_empty" ] && exit 0
  echo
  echo
  exit 0
fi
cwd="$(cat "$cwd_file" | head -n1)"

[ -n "$extra_line" ] && echo
echo "$file"
echo "$cwd"
