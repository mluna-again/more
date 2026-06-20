#! /usr/bin/env bash

if ! command -v zfs &>/dev/null; then
  exit 0
fi

printf "#[bg=#{@black1},fg=default] "
zfs list -H -o name,used,available -s name -d 0 -p | \
  awk '{
  usage = (($2 / ($2 + $3)) * 100);
  if (usage >= 90) {
    printf "%s: #[fg=#{@red}]%0.2f%%#[fg=default] ", $1, usage;
  } else if (usage >= 80) {
    printf "%s: #[fg=#{@yellow}]%0.2f%%#[fg=default] ", $1, usage;
  } else {
    printf "%s: %0.2f%% ", $1, usage;
  }
}'
printf "#[bg=default,fg=default]"
