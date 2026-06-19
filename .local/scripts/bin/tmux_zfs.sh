#! /usr/bin/env bash

if ! command -v zfs &>/dev/null; then
  exit 0
fi

printf "#[bg=#{@black1},fg=default] "
zfs list -H -o name,used,available -s name -d 0 -p | \
  awk '{printf "%s %0.2f\n", $1, ($2/($2+$3))*100}' | \
  awk '{
  if ($2 >= 90) {
    printf "%s: #[fg=#{@red}]%s%%#[fg=default] ", $1, $2;
  } else if ($2 >= 80) {
    printf "%s: #[fg=#{@yellow}]%s%%#[fg=default] ", $1, $2;
  } else {
    printf "%s: %s%% ", $1, $2;
  }
}'
printf "#[bg=default,fg=default]"
