#! /usr/bin/env bash

_CACHE_DIR="$HOME/.cache/pdfviewer.sh"

usage() {
  cat - <<EOF
Converts a pdf to jpg files in a temp folder, and lets you slide through them using the kitty protocol.
$ pdfviewer.sh <pdf file>
$ pdfviewer.sh --delete <pdf file> # remove temp files
EOF
  exit 1
}

pdfdir() {
  local file_hash
  file_hash=$(md5sum <<< "$1" | awk '{print $1}')
  echo "$_CACHE_DIR/$file_hash"
}

_delete=0
file=
while true; do
  [ -z "$1" ] && break
  case "$1" in
    --help|-h|help)
      usage
      ;;

    --delete)
      _delete=1
      ;;

    *)
      file="$1"
      ;;
  esac
  shift
done

if (( _delete == 1 )); then
  rm -rf "$(pdfdir "$file")"
  exit 1
fi

[ -z "$file" ] && usage
if [ ! -f "$file" ]; then
  echo "File not readable" 1>&2
  exit 1
fi

fname_by_index() {
  local index dir
  index="$1"
  dir="$2"

  find "$dir" -type f | sort -h | awk "NR==$index"
}

display_img() {
  local h
  h=$(tput lines)
  h=$(( h - 1)) # helpbar
  chafa --size x"$h" "$1" --center on --format kitty
}

helpbar() {
  local dir current msg padd width msg_w
  dir="$1"
  current="$2"
  total=$(find "$dir" -type f | wc -l | xargs)
  msg="quit (q), next (n), previous (p), g (first), G (last) [${current}/${total}]"
  msg_w="${#msg}"
  width=$(tput cols)
  padd=$(( (width - msg_w) / 2 ))
  for (( i = 0; i < padd; i++ )); do printf " "; done
  echo -n "$msg"
}

last_index() {
  find "$dir" -type f | wc -l | xargs
}

dir=$(pdfdir "$file")
if [ -d "$dir" ]; then
  echo "Directory for $file already exists. Reusing assets." 1>&2
else
  mkdir -p "$dir"
  pdftocairo -jpeg "$file" "$dir/$file" || exit
fi

index=1
tput smcup || exit
trap 'tput rmcup' EXIT
display_img "$(fname_by_index "$index" "$dir")"
helpbar "$dir" "$index"
while read -r -N 1 key; do
  case "$key" in
    q)
      break
      ;;
    n)
      (( index++ ))
      next_fname=$(fname_by_index "$index" "$dir")
      [ ! -f "$next_fname" ] && index=1
      ;;
    p)
      (( index-- ))
      (( index < 1 )) && index=$(last_index)
      ;;

    g)
      index=1
      ;;

    G)
      index=$(last_index)
      ;;

    *)
      # avoid extra render
      continue
      ;;
  esac

  fname=$(fname_by_index "$index" "$dir")
  clear
  display_img "$fname"
  helpbar "$dir" "$index"
done


