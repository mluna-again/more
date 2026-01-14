#! /usr/bin/env bash

usage() {
  cat - <<EOF
Usage
$ ffmpeg_vr_to_flat.sh <video>

Options
  -h, --help                  show this message
  -o FILE, --output FILE      specify output file
  -h HEIGHT, --height HEIGHT  output height
  -w WIDTH, --width WIDTH     output width
  --fish                      use fisheye mode instead of equirect
EOF
  exit 1
}

[ -z "$*" ] && usage

while true; do
  [ -z "$1" ] && break

  case "$1" in
    --help|-h|help)
      usage
      ;;

    -o|--output)
      shift
      output="$1"
      ;;

    -h|--height)
      shift
      height="$1"
      ;;

    -w|--width)
      shift
      width="$1"
      ;;

    --fish)
      mode="fisheye"
      ;;

    *)
      file="$1"
      ;;
  esac

  shift
done

[ -z "$file" ] && exit

video_info=$(ffprobe -v error -show_entries stream=width,height "$file") || exit

[ -z "$mode" ] && mode=equirect
if [ -z "$output" ]; then
  output="$(sed 's|\(.*\)\.\(.*\)|\1_flat\.\2|' <<< "$file")" || exit
fi
if [ -z "$height" ]; then
  height="$(awk -F= '$1=="height" {print $2}' <<< "$video_info")" || exit
fi
if [ -z "$width" ]; then
  width="$(awk -F= '$1=="width" {print $2}' <<< "$video_info")" || exit
fi

echo "OUTPUT FILE: $output"
echo "VIDEO RES: ${width}x${height}"
echo "MODE: $mode"
printf "Continue? [N/y] "
read -r response
if ! grep -iE "^y(es)?$" <<< "$response"; then
  exit 1
fi

case "${mode,,}" in
  equirect)
    ffmpeg -i "$file" -filter:v "v360=input=hequirect:output=flat:in_stereo=sbs:out_stereo=2d:d_fov=125:w=$width:h=$height:pitch=-30" -map 0 -c copy -c:v libx265 -crf 18 -pix_fmt yuv420p "$output"
    ;;

  fisheye)
    ffmpeg -i "$file" -filter:v "v360=input=fisheye:ih_fov=200:iv_fov=200:output=flat:in_stereo=sbs:out_stereo=2d:d_fov=125:w=$width:h=$height:pitch=-30" -map 0 -c copy -c:v libx265 -crf 18 -pix_fmt yuv420p "$output"
    ;;

  *)
    echo "Invalid mode" >&2
    exit 1
    ;;
esac
