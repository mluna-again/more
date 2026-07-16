#! /usr/bin/env bash

# shellcheck disable=SC2120
usage() {
  cat - <<EOF
Usage:
$ pgrep curl | ${0##*/} <cmd> [<args...>]
$ ${0##*/} -e curl -- <cmd> [<args...>]

Sleeps until all PIDs read from STDIN exit, then runs <cmd>.
Make sure to use \`... | sudo ${0##*/} <cmd> [<args...>]\` if your cmd needs sudo, otherwise it will block until you come back or fail.

Supports -- to separate ${0##*/} flags from <cmd> flags.

Flags:
  --help | -h                       show this message
  --pgrep <patter> | -e <pattern>   instead of reading PIDs from STDIN, run \`pgrep -f "<pattern>"\` until it returns a non-zero code. can be supplied multiple times.
                                    if supplied multiple times, wait until all patterns return a non-zero code.
  --sleep <n> | -s <n>              how much time to sleep (in seconds) between --pgrep checks. default 30
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
expressions=()
cmd=()
sleep_time=30
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

    --pgrep|-e)
      shift
      expressions=( "$1" )
      ;;

    --sleep|-s)
      shift
      sleep_time="$1"
      if ! [[ "$sleep_time" =~ ^[0-9]+$ ]]; then
        usage Invalid --sleep value
      fi
      ;;

    *)
      cmd+=( "$1" )
      ;;
  esac

  shift
done

procs=()
if [ "${#expressions[@]}" -eq 0 ]; then
  while read -r pid; do
    echo "$pid"
    procs=( --pid="$pid" )
    procs_found=1
  done
fi

if [ "${#expressions[@]}" -eq 0 ] && [ -z "$procs_found" ]; then
  usage No procs and no --pgrep args given
fi

log="after-$(date +%Y-%m-%dT%H:%M:%S%z).log"
: > "$log"

if [ -n "$procs_found" ]; then
  tail --follow /dev/null "${procs[@]}" 2>>"$log" || exit
else
  while true; do
    still_alive=
    for e in "${expressions[@]}"; do
      if pgrep -f "$e" >/dev/null 2>>"$log"; then
        still_alive=1
        break
      fi
    done
    unset e

    if [ -z "$still_alive" ]; then
      break
    else
      sleep "$sleep_time"
    fi
  done
  unset still_alive
fi

echo "Running ${cmd[*]}" >> "$log"
"${cmd[@]}" &>> "$log"
