#! /usr/bin/env bash

count=0
for c in {0..255}; do
  color=$(printf "%-5s" "$c")
  tput setab "$c"
  if (( count >= 15 )); then
    echo -n "$color"
    echo
    count=0
    continue
  fi
  echo -n "$color"
  (( ++count ))
done

tput sgr0
echo
echo "How to's"
echo "Reset: tput sgr0"
echo "Background color: tput setab [CODE]"
echo "Foreground color: tput setaf [CODE]"

