#! /usr/bin/env bash

die() {
  echo "$*" 1>&2
  exit 1
}

usage() {
  cat - <<EOF
Adds an alias entry to ~/.ssh/config for the given VM.
Honors \`users\` file.
If an entry exists it's updated.
Displays a diff preview with \`diff\` or \`delta\` if installed.

Usage:
$ vm_alias.sh <fzf-able vm name>

Flags:
  -p PORT, --port PORT    add LocalForward to PORT. can be supplied multiple times. (default: [])
EOF
  exit 1
}

vm=""
ports=()
while true; do
  [ -z "$1" ] && break

  case "$1" in
    --help|-h|help)
      usage
      ;;

    -p|--port)
      shift
      ports+=( "$1" )
      ;;
      
    *)
      vm="$(find ~/VMs -maxdepth 1 -mindepth 1 -type f -exec basename {} \; | fzf -1 -q "$1")" || exit
      vm="$(basename "$vm" .conf)" || exit
      ;;
  esac

  shift
done

if [ -z "$vm" ]; then
  die vm required
fi

_user=$(awk -F, "\$1 == \"$vm\" { print \$2 }" ~/VMs/users)
_port=$(awk -F, "\$1 == \"$vm\" { print \$3 }" ~/VMs/users)

generate() {
  cat - <<EOF
Host $vm
  Hostname localhost
  Port ${_port:-22220}
  User ${_user:-user}
  RequestTTY yes
EOF
  for port in "${ports[@]}"; do
    echo "  LocalForward ${port} localhost:${port}"
  done
}

rebuild_config_file() {
  if grep -Eiq "Host\s+$vm" ~/.ssh/config; then
    # s: current host block start
    # e: current host block end
    without_entry="$(awk "{
        if (\$1 == \"Host\" && s==1) { e=1; }
        if (\$2 == \"$vm\") { s=1; }
        if (s==0 || e==1) { print \$0; }
      }" ~/.ssh/config
    )"
  else
    without_entry="$(cat ~/.ssh/config)"
  fi
  echo "$without_entry"
  [[ "$(echo "$without_entry" | tail -c2 | wc -l)" -gt 1 ]] || echo
  generate
}

newversion="$(mktemp /tmp/vm_alias.XXXXX)" || exit
cleanup() {
  rm "$newversion"
}
trap cleanup EXIT

entry_lines="$(generate | wc -l)"
rebuild_config_file > "$newversion" || exit

if command -v delta &>/dev/null; then
  if delta --paging=never --side-by-side ~/.ssh/config "$newversion"; then
    echo
    echo no changes required
    exit
  fi
else
  if diff --color=always --suppress-common-lines --unified="$entry_lines"  ~/.ssh/config "$newversion"; then
    echo
    echo no changes required
    exit
  fi
fi

printf "Continue? [N/y] "
read -r response
if [[ ! "${response,,}" =~ ^y(es)?$ ]]; then
  exit 1
fi

cp "$newversion" ~/.ssh/config
