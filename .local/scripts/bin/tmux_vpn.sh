#! /usr/bin/env bash

command -v nmcli &>/dev/null || exit

if nmcli con show --active | grep -qi -e vpn -e wireguard -e tun -e tap; then
  echo "#[bg=#{@yellow},fg=#{@black2}] VPN #[bg=default,fg=default] "
fi
