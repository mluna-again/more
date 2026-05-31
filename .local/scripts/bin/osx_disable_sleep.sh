#! /usr/bin/env bash

set -x

cleanup() {
  sudo pmset -b disablesleep 0
}
trap cleanup EXIT

sudo pmset -b disablesleep 1

while true; do
  sleep 100000
done
