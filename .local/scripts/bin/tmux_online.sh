#! /usr/bin/env bash

if ! ping -W 1 -c 1 8.8.8.8 &>/dev/null && ! ping -W 1 -c 1 1.1.1.1 &>/dev/null; then
  echo " OFF "
fi
