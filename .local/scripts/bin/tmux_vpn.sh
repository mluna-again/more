#! /usr/bin/env bash

command -v nmcli &>/dev/null || exit

match="$(nmcli -f NAME,TYPE,ACTIVE con show --active | awk '$3 == "yes" {print $1, $2}' | grep -e vpn -e wireguard -e tun -e tap | awk '{print $1}')"
if [ -n "$match" ] ; then
  match_count="$(echo "$match" | wc -l)"
  if (( match_count == 1 )) && [[ "$match" =~ ^.*tailscale.*$ ]]; then
    if tailscale status --self &>/dev/null; then
      echo "#[bg=#{@yellow},fg=#{@black2}] VPN #[bg=default,fg=default] "
    fi
  else
    echo "#[bg=#{@yellow},fg=#{@black2}] VPN #[bg=default,fg=default] "
  fi
fi
