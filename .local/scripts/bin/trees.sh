#! /usr/bin/env bash

_WORKTREES="$PWD/.worktrees"

error() {
  tput setab 1
  tput setaf 0
  printf " ERR " >&2
  tput sgr0
  printf " %s " "$*" >&2
  echo
}

warn() {
  tput setab 3
  tput setaf 0
  printf " WARN " >&2
  tput sgr0
  printf " %s " "$*" >&2
  echo
}

debug() {
  tput setab 3
  tput setaf 0
  printf " DEBUG " >&2
  tput sgr0
  printf " %s " "$*" >&2
  echo
}

check_git() {
  if [ ! -d .git ] && [ ! -f .git ]; then
    error "Not inside a Git Repo."
    exit 1
  fi

  if ! git check-ignore -q .worktrees/; then
    warn "You don't have .worktrees ignored"
  fi
}

# shellcheck disable=SC2120
usage() {
  cat - <<EOF >&2
Usage:
$ ${0##*/} <command> [<arg>]

Commands:
  list, l, ls           lists available worktrees
  create, c [<name>]    creates a new worktree
  remove, rm [<name>]   removes a worktree
  cd [<name>]           print the path to a worktree. useful like this: cd (trees.sh cd)

Hooks:
  You can set scripts to run automatically after some actions.
  Set one of the following env variables, pointing to a script, to run them.

  - WK_ON_CREATE    Runs after a \`create\`.
                    It receives the path of the created worktree as \$1.
                    Make sure your script is executable.

Flags:
  --help | -h    show this message
EOF
  if [ "$#" -gt 0 ]; then
    echo
    error "$*"
  fi
  exit 1
}

hooks() {
  local action="$1" script args
  shift
  args=( "$@" )

  case "$action" in
    create)
      script="$WK_ON_CREATE"
      [ -z "$script" ] && return 0

      debug "WK_ON_CREATE: Running $script ${args[*]}"
      "$script" "${args[@]}"
      return
      ;;
  esac
}

action=
action_arg=
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
[ -z "$action" ] && usage Missing action

case "$action" in
  cd)
    check_git
    if [ -f .git ]; then
      repo=$(awk -F': ' '{print $2}' .git | sed 's|\.git.*||') || exit
      error "Inside Worktree. Going back to original repo."
      echo "$repo"
      exit 1
    fi

    response=$(git worktree list | fzf -1 -q "$action_arg" | awk '{print $1}')
    if [ -z "$response" ]; then
      exit 1
    fi

    hooks cd
    echo "$response"
    ;;

  list|l|ls)
    check_git
    if [ -f .git ]; then
      repo=$(awk -F': ' '{print $2}' .git | sed 's|\.git.*||') || exit
      git -C "$repo" worktree list
      exit 0
    fi

    hooks list
    git worktree list
    ;;

  create|c)
    check_git
    if [ -f .git ]; then
      error "Inside Worktree. Go back to the original repo and try again."
      exit 1
    fi
    tree_name="${action_arg}"
    if [ -z "$tree_name" ]; then
      printf "Name: "
      read -r tree_name || exit
    fi
    tree_name=$(sed 's| |_|g' <<< "$tree_name")
    if [ -z "$tree_name" ]; then
      error "Name required. Bye."
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
      error "Branch required. Bye."
      exit 1
    fi

    tree_name=$(sed 's|[ /]|_|g' <<< "$tree_name") # i do this *after* assigning branch, i want to preserve the branch name
    printf "\nName: %s\nBranch: %s\nPath: %s/%s\n\nContinue? [N/y] " "$tree_name" "$branch" "$_WORKTREES" "$tree_name"
    read -r response || exit
    [ "${response,,}" != y ] && exit 1

    wpath="${_WORKTREES}/$tree_name"
    if git rev-parse --verify "$branch" &>/dev/null; then
      git worktree add "$wpath" --checkout "$branch" || exit
    else
      git worktree add "$wpath" -b "$branch" || exit
    fi

    hooks create "$wpath"
    echo
    echo "$wpath"
    ;;

  remove|rm)
    if [ -f .git ]; then
      error "Inside Worktree. Go back to the original repo and try again."
      exit 1
    fi
    trees=$(find "$_WORKTREES" -maxdepth 1 -mindepth 1 -type d 2>/dev/null | sed "s|${_WORKTREES}/||")
    if [ -z "$trees" ]; then
      error "No worktrees found."
      exit 1
    fi

    tree=$(echo "$trees" | fzf -1 -q "$action_arg")
    [ -z "$tree" ] && exit 1

    branch=$(git -C "${_WORKTREES}/$tree" branch --show-current) || exit
    if [ -z "$branch" ]; then
      error "Could not fetch branch."
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

    hooks remove
    git branch -d "$branch"
    ;;

  *)
    usage "Invalid action: $action"
    ;;
esac
