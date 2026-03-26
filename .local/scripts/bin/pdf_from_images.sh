#! /usr/bin/env bash

die() {
  echo "$*" 1>&2
  exit 1
}

if ! command -v magick &>/dev/null; then
  die "magick required."
fi

add_image_if_exist() {
  if [ -f "$1" ]; then
    images+=( "$1" )
  else
    echo "$1: what is this?" >&2
    return 1
  fi
}

usage() {
  cat - <<EOF
Makes a PDF from a set of images.
Compresses images by default.

Usage:
$ find . -iname "*.jpeg" | pdf_from_images.sh
$ pdf_from_images.sh *.jpeg

Flags:
  -x LEVEL, --quality LEVEL      compression level, magick -quality arg. 0-100% (default: 85%)
  -o FILE, --output FILE         file name (default: pictures.pdf)
EOF
  exit 1
}

quality="85%"
output=pictures.pdf
images=()
while true; do
  [ -z "$1" ] && break

  case "$1" in
    --help|-h|help)
      usage
      ;;

    -x|--quality)
      shift
      quality="$1"
      ;;

    -o|--output)
      shift
      output="$1"
      ;;

    *)
      add_image_if_exist "$1" || exit
      ;;
  esac

  shift
done

if ! [[ "$quality" =~ ^[0-9]{0,2}%$ ]]; then
  die "$quality: invalid quality value"
fi

if [ -f "$output" ]; then
  die "$output already exists."
fi

tmpdir=$(mktemp --directory) || exit
cleanup() {
  rm -rf "$tmpdir"
}
trap cleanup EXIT

if [ "${#images[@]}" -eq 0 ]; then
  while read -r file; do
    add_image_if_exist "$file" || exit
  done
fi

count=1
total="${#images[@]}"
for image in "${images[@]}"; do
  echo "[${count}/${total}] Processing ${image}..."
  magick "$image" -strip -interlace Plane -gaussian-blur 0.05 -quality "$quality" "${tmpdir}/${image}" || exit
  (( ++count ))
done

echo "Making PDF..."
magick "$tmpdir/*" "$output"
echo "Done."
