#! /usr/bin/env bash

# Automatically commits Org mode files in ~/Org at a specific time
# You can just copy this file to /etc/cron.daily/
_HOME=/home/void
_GIT_USER=void
_GIT_EMAIL=example@void.com

# Uncomment this if you need help debugging this thing
# exec > >(tee "$_HOME/commit-org.log") 2>&1

die() {
  echo "$*" 1>&2
  exit 1
}

# returns non-0 when there are changes
are_there_changes() {
  git status --porcelain=v1 2>/dev/null | wc -l
}

date_formatted() {
  date "+%Y-%m-%dT%H:%M:%S%z"
}

log() {
  printf "[%s] %s\n" "$*" "$(date_formatted)"
}

if ! command -v git &>/dev/null; then
  die git is not installed
fi

cd "$_HOME/Org" || exit

if [ ! -d .git ]; then
  git init || exit
fi

git config user.name "$_GIT_USER" || exit
git config user.email "$_GIT_EMAIL" || exit

if [ "$(are_there_changes)" -eq 0 ]; then
  log no changes
  exit
fi

git add . || exit
git commit -m "$(date_formatted)" || exit
