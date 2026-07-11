#! /usr/bin/env bash

command -v nmcli &>/dev/null || exit

join() {
  local count=0 index=0 lines=() line sep="$1"

  while read -r line; do
    lines+=( "$line" )
    (( count++ ))
  done

  while (( index < count )); do
    printf "%s" "${lines[$index]}"
    if (( index < ( count - 1 ) )); then
      printf "%s" "$sep"
    fi
    (( index++ ))
  done
}

filter_tailscale() {
  local line

  while read -r line; do
    if [[ "$line" =~ ^tailscale[0-9]*$ ]]; then
      if tailscale status --browser=false &>/dev/null; then
        echo tailscale
      fi
    else
      echo "$line"
    fi
  done
}

matches="$(nmcli -f NAME,TYPE,ACTIVE con show --active | awk '$3 == "yes" {print $1, $2}' | grep -e vpn -e wireguard -e tun -e tap | awk '{print $1}' | filter_tailscale | join /)"
if [ -n "$matches" ] ; then
  echo "#[bg=#{@yellow},fg=#{@black2}] $matches #[bg=default,fg=default] "
fi
