#! /usr/bin/env bash

command -v nmcli &>/dev/null || exit

if nmcli con show --active | grep -qi -e vpn -e wireguard -e tun -e tap; then
  echo " VPN "
fi
