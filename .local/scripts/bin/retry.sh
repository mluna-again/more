#! /usr/bin/env bash

# shellcheck disable=SC2120
usage() {
  cat - <<EOF
Usage:
$ ${0##*/} <cmd> [<arg>...]

Run <cmd> <n> times, or until it returns 0 status code.

Flags:
  --help | -h              show this message
  --retries <n> | -n <n>   number of retries. default: 5
  --wait <n> | -w <n>      number, in seconds, to wait between retries. a special value of 'random' will select a random number between 0 and 60 each time. default: 3

Examples:
  $ retry.sh -w 300 -n 10 -- curl "\$link" -o /tmp/some_website_index.html # Try 10 times to download \$link, and sleep 5 minutes between each retry
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

flags_done=
retries=5
sleep_time=3
cmd=()
while true; do
  [ -z "$1" ] && break

  if [ -n "$flags_done" ]; then
    cmd+=( "$1" )
    shift
    continue
  fi

  case "$1" in
    --) flags_done=1 ;;

    --help|-h)
      usage
      ;;

    --retries|-n)
      shift
      retries="$1"
      if ! [[ "$retries" =~ ^[0-9]+$ ]]; then
        usage Invalid --retries value
      fi
      ;;

    --wait|-w)
      shift
      sleep_time="$1"
      if ! [[ "$sleep_time" =~ ^[0-9]+$ ]] && [ "$sleep_time" != random ]; then
        usage Invalid --wait value
      fi
      ;;

    *)
      cmd+=( "$1" )
      ;;
  esac

  shift
done

if [ "${#cmd[@]}" -eq 0 ]; then
  usage Missing cmd
fi

i=0
last_code=
while (( i < retries )); do
  "${cmd[@]}"
  last_code="$?"
  [ "$last_code" -eq 0 ] && break

  if ! (( i + 1 >= retries )); then
    if [ "$sleep_time" = random ]; then
      _time="$(( RANDOM % 60 ))"
      sleep "$_time"
    else
      sleep "$sleep_time"
    fi
  fi
  (( i++ ))
done

exit "$last_code"
