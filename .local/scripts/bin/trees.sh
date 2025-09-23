#! /usr/bin/env bash

_WORKTREES="$HOME/Worktrees"

stderr() {
  echo "$*" 1>&2
}

check_git() {
  if [ ! -d .git ] && [ ! -f .git ]; then
    stderr "Not inside a Git Repo."
    exit 1
  fi
}

usage() {
  cat - <<EOF
Usage:
$ trees.sh <command>

Commands:
  list, l, ls      lists available worktrees
  create, c        creates a new worktree
  remove, rm       removes a worktree
  dir              print the path to a worktree. useful like this: cd (trees.sh dir)
EOF
  exit 1
}

while true; do
  [ -z "$1" ] && break

  case "$1" in
    --help|-h|help)
      usage
      ;;

    *)
      action="$1"
      ;;
  esac

  shift
done
[ -z "$action" ] && usage

case "$action" in
  dir)
    check_git
    if [ -f .git ]; then
      repo=$(awk -F': ' '{print $2}' .git | sed 's|\.git.*||') || exit
      stderr "Inside Worktree. Going back to original repo."
      echo "$repo"
      exit 0
    fi

    git worktree list | fzf | awk '{print $1}'
    ;;
  list|l|ls)
    check_git
    if [ -f .git ]; then
      repo=$(awk -F': ' '{print $2}' .git | sed 's|\.git.*||') || exit
      echo "Inside Worktree. Original: $repo"
      exit 0
    fi
    git worktree list
    ;;

  create|c)
    check_git
    base=$(basename "$(pwd)") || exit
    printf "Name: "
    read -r response || exit
    tree_name="$response"
    if [ -z "$tree_name" ]; then
      stderr "Name required. Bye."
      exit 1
    fi

    printf "Git branch [Name|branch|fzf]: "
    read -r response || exit
    if [ "$response" = fzf ]; then
      branch=$(git branch --sort=-committerdate -a --format='%(refname:short)' | fzf)
    elif [ -z "$response" ] || [ "${response,,}" = name ]; then
      branch="$tree_name"
    else
      branch="$response"
    fi
    if [ -z "$branch" ]; then
      stderr "Branch required. Bye."
      exit 1
    fi

    printf "\nName: %s\nBranch: %s\nPath: %s/%s/%s\n\nContinue? [N/y] " "$tree_name" "$branch" "$_WORKTREES" "$base" "$tree_name"
    read -r response || exit
    [ "${response,,}" != y ] && exit 1

    if git rev-parse --verify "$branch" &>/dev/null; then
      git worktree add "${_WORKTREES}/$base/$tree_name" --checkout "$branch" || exit
    else
      git worktree add "${_WORKTREES}/$base/$tree_name" -b "$branch" || exit
    fi

    echo cd "${_WORKTREES}/$base/$tree_name"
    ;;

  remove|rm)
    trees=$(find "$_WORKTREES" -maxdepth 2 -mindepth 2 -type d | sed "s|${_WORKTREES}/||")
    if [ -z "$trees" ]; then
      stderr "No worktrees found."
      exit 1
    fi

    tree=$(echo "$trees" | fzf)
    [ -z "$tree" ] && exit 1
    printf "Deleting %s\nContinue? [N/y] " "$tree"
    read -r response || exit
    [ "${response,,}" != y ] && exit 1
    git worktree remove "$tree"
    ;;
esac
