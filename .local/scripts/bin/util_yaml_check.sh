#! /usr/bin/env bash

file="$1"

if [ -n "$file" ]; then
  python3 -c 'import yaml, sys; yaml.safe_load(sys.stdin)' < "$file"
else
  python3 -c 'import yaml, sys; yaml.safe_load(sys.stdin)'
fi
