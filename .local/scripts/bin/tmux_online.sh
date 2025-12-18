#! /usr/bin/env bash

if ! ping -w 1 -c 1 8.8.8.8 &>/dev/null && ! ping -w 1 -c 1 1.1.1.1 &>/dev/null; then
  echo " OFF "
fi
