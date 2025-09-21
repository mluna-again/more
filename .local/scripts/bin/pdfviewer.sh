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
  local index ext
  index="$1"
  ext="$2"
  fname=$(sed "s/[0-9]+.$ext$//" <<< "$dir/$file")
  fname="${fname}-${index}.${ext}"
  echo "$fname"
}

display_img() {
  chafa "$1" --format kitty
}

helpbar() {
  echo "quit (q), next (n), previous (p)"
}

dir=$(pdfdir "$file")
if [ -d "$dir" ]; then
  echo "Directory for $file already exists. Reusing assets." 1>&2
else
  mkdir -p "$dir"
  pdftocairo -jpeg "$file" "$dir/$file" || exit
fi

index=1
ext=jpg
display_img "$(fname_by_index "$index" "$ext")"
helpbar
while read -r -N 1 key; do
  fname=$(fname_by_index "$index" "$ext")

  case "$key" in
    q)
      break
      ;;
    n)
      (( index++ ))
      next_fname=$(fname_by_index "$index" "$ext")
      [ ! -f "$next_fname" ] && index=1
      ;;
    p)
      (( index-- ))
      (( index <= 1 )) && index=$(find "$dir" -type f -iname "*$ext" | wc -l)
      ;;
  esac

  clear
  display_img "$fname"
  helpbar
done
