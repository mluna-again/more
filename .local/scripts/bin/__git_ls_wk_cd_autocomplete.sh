#! /usr/bin/env bash

{
  r="$(git remote 2>/dev/null)" || exit
  git branch --all --format '%(refname:short)' 2>/dev/null | grep -xv "$r" | sed "s|${r}/||" || exit
  git worktree list 2>/dev/null | awk '{print $3}' | sed -e 's|\[||' -e 's|\]||' || exit
} | sort | uniq

