#! /usr/bin/env bash

# shellcheck disable=SC2120
usage() {
  cat - <<EOF
Usage:
$ pgrep curl | ${0##*/} <cmd> [<args...>]

Sleeps until all PIDs read from STDIN exit, then runs <cmd>.
Make sure to use \`... | sudo ${0##*/} <cmd> [<args...>]\` if your cmd needs sudo, otherwise it will block until you come back or fail.

Flags:
  --help | -h      show this message
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

cmd=()
while true; do
  [ -z "$1" ] && break

  case "$1" in
    --help|-h)
      usage
      ;;

    *)
      cmd+=( "$1" )
      ;;
  esac

  shift
done

procs_found=
procs=()
while read -r pid; do
  echo "$pid"
  procs=( --pid="$pid" )
  procs_found=1
done

[ -z "$procs_found" ] && usage No procs

tail --follow /dev/null "${procs[@]}" || exit

log="after-$(date +%Y-%m-%dT%H:%M:%S%z).log"
echo "Running ${cmd[*]}" > "$log"
"${cmd[@]}" &>> "$log"
