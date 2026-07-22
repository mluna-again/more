#! /usr/bin/env bash

# shellcheck disable=SC2120
usage() {
  cat - <<EOF
Usage:
$ pgrep curl | ${0##*/} <cmd> [<args...>]

Sleeps until all PIDs read from STDIN exit, then runs <cmd>.
Make sure to use \`... | sudo ${0##*/} <cmd> [<args...>]\` if your cmd needs sudo, otherwise it will block until you come back or fail.

Supports -- to separate ${0##*/} flags from <cmd> flags.

Flags:
  --help | -h                       show this message
  --pgrep <patter> | -e <pattern>   instead of reading PIDs from STDIN, run \`pgrep "<pattern>"\` until it returns a non-zero code. can be supplied multiple times.
                                    if supplied multiple times, wait until all patterns return a non-zero code.
  --sleep <n> | -s <n>              how much time to sleep (in seconds) between --pgrep checks. default 30
  --wait <n>  | -w <n>              wait for aditional <n> seconds before checking again, before running <cmd>. only really makes sense with --pgrep

Examples:
$ pgrep curl | ${0##*/} systemctl poweroff         # turn off your PC after all running (at the time of executing ${0##*/}) curl processes exit.
$ ${0##*/} -e curl -- systemctl poweroff           # same thing, but check for curl processes every 30 seconds instead of using a static PID list
$ ${0##*/} -e curl -w 300 -- systemctl poweroff    # same thing, but after the check returns 0 processes, wait 5 minutes, re-check again,
                                                   # and if it still returns 0 processes, then it shuts down. otherwise it starts checking again
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
wait_time=
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

    -w|--wait)
      shift
      wait_time="$1"
      if ! [[ "$wait_time" =~ ^[0-9]+$ ]]; then
        usage Invalid --wait value
      fi
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

if [ "${#cmd[@]}" -eq 0 ]; then
  usage Missing cmd
fi

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


_log="$(mktemp)" || exit
cleanup() { rm -f "$_log" ; }
trap cleanup EXIT

waited=
if [ -n "$procs_found" ]; then
  while true; do
    tail --follow /dev/null "${procs[@]}" 2>>"$_log" || exit
    if [ -n "$wait_time" ] && [ -z "$waited" ]; then
      sleep "$wait_time"
      waited=1
    else
      break
    fi
  done
else
  while true; do
    still_alive=
    for e in "${expressions[@]}"; do
      if pgrep "$e" >/dev/null 2>>"$_log"; then
        still_alive=1
        break
      fi
    done
    unset e

    if [ -z "$still_alive" ]; then
      if [ -n "$wait_time" ] && [ -z "$waited" ]; then
        sleep "$wait_time"
        unset still_alive
        waited=1
        continue
      fi
      break
    else
      sleep "$sleep_time"
      waited=
    fi
  done
  unset still_alive
fi

log="after-$(date +%Y-%m-%dT%H:%M:%S%z).log"
{
  cat "$_log"
  echo "----------------------------"
  echo "Running: ${cmd[*]}"
  echo "Parameters:"
  echo "  --pgrep ${expressions[*]}"
  echo "  --sleep ${sleep_time}"
  echo "  --wait ${wait_time}"
  echo "----------------------------"
  echo "OUTPUT:"
} > "$log"
"${cmd[@]}" &>> "$log"
