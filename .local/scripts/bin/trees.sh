#! /usr/bin/env bash

_WORKTREES="$PWD/.worktrees"

stderr() {
  echo "$*" 1>&2
}

check_git() {
  if [ ! -d .git ] && [ ! -f .git ]; then
    stderr "Not inside a Git Repo."
    exit 1
  fi

  if ! grep -q .worktrees .gitignore; then
    stderr "[WARN] You don't have .worktrees ignored"
  fi
}

usage() {
  cat - <<EOF >&2
Usage:
$ trees.sh <command> [<arg>]

Commands:
  list, l, ls           lists available worktrees
  create, c [<name>]    creates a new worktree
  remove, rm [<name>]   removes a worktree
  cd [<name>]          print the path to a worktree. useful like this: cd (trees.sh cd)

Flags:
  --help | -h    show this message
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
      if [ -z "$action" ]; then
        action="$1"
      elif [ -z "$action_arg" ]; then
        action_arg="$1"
      fi
      ;;
  esac

  shift
done
[ -z "$action" ] && usage

case "$action" in
  cd)
    check_git
    if [ -f .git ]; then
      repo=$(awk -F': ' '{print $2}' .git | sed 's|\.git.*||') || exit
      stderr "Inside Worktree. Going back to original repo."
      echo "$repo"
      exit 0
    fi

    response=$(git worktree list | fzf -1 -q "$action_arg" | awk '{print $1}')
    if [ -z "$response" ]; then
      pwd
      exit 0
    fi

    echo "$response"
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
    tree_name="${action_arg}"
    if [ -z "$tree_name" ]; then
      printf "Name: "
      read -r tree_name || exit
    fi
    tree_name=$(sed 's| |_|g' <<< "$tree_name")
    if [ -z "$tree_name" ]; then
      stderr "Name required. Bye."
      exit 1
    fi

    printf "Git branch [%s|fzf|<other>]: " "$tree_name"
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

    printf "\nName: %s\nBranch: %s\nPath: %s/%s\n\nContinue? [N/y] " "$tree_name" "$branch" "$_WORKTREES" "$tree_name"
    read -r response || exit
    [ "${response,,}" != y ] && exit 1

    if git rev-parse --verify "$branch" &>/dev/null; then
      git worktree add "${_WORKTREES}/$tree_name" --checkout "$branch" || exit
    else
      git worktree add "${_WORKTREES}/$tree_name" -b "$branch" || exit
    fi

    echo
    echo "${_WORKTREES}/$tree_name"
    ;;

  remove|rm)
    if [ -f .git ]; then
      repo=$(awk -F': ' '{print $2}' .git | sed 's|\.git.*||') || exit
      stderr "Inside Worktree. Go back to the original repo and try again."
      echo "$repo"
      exit 1
    fi
    trees=$(find "$_WORKTREES" -maxdepth 2 -mindepth 1 -type d | sed "s|${_WORKTREES}/||")
    if [ -z "$trees" ]; then
      stderr "No worktrees found."
      exit 1
    fi

    tree=$(echo "$trees" | fzf -1 -q "$action_arg")
    [ -z "$tree" ] && exit 1

    branch=$(git -C "${_WORKTREES}/$tree" branch --show-current) || exit
    if [ -z "$branch" ]; then
      stderr "Could not fetch branch."
      exit 1
    fi

    printf "Deleting %s\nContinue? [N/y] " "$tree"
    read -r response || exit
    [ "${response,,}" != y ] && exit 1
    git worktree remove "$tree" || exit

    printf "Remove branch (%s)? [N/y] " "$branch"
    read -r response
    if [[ ! "${response,,}" =~ ^y(es)?$ ]]; then
      exit 1
    fi
    git branch -d "$branch"
    ;;

  *)
    echo "Invalid action: $action" >&2
    ;;
esac
