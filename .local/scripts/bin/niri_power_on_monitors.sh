#! /usr/bin/env bash

niri msg action power-on-monitors || exit
niri msg --json outputs | jq -r '.|to_entries[].value.name' | xargs -I{} niri msg output {} on
