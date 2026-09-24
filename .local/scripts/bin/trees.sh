#! /usr/bin/env bash

_WORKTREES=".."

success() {
  tput setab 2
  tput setaf 0
  printf " OK " >&2
  tput sgr0
  printf " %s " "$*" >&2
  echo
}

info() {
  tput setab 4
  tput setaf 0
  printf " INFO " >&2
  tput sgr0
  printf " %s " "$*" >&2
  echo
}

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

_common_dir() {
  readlink -m "$(git rev-parse --git-common-dir)"
}

check_git() {
  if ! git rev-parse --git-dir &>/dev/null; then
    error "Not inside a Git Repo."
    exit 1
  fi
}

# shellcheck disable=SC2120
usage() {
  cat - <<EOF >&2
Usage:
$ ${0##*/} <command> [<arg>]

Commands:
  list, l, ls           lists available worktrees
  remove, rm [<name>]   removes a worktree
  cd [<name>]           print the path to a worktree, creating it if necessary. useful like this: cd (trees.sh cd)

Environment variables:
  You can customize the behaviour of this program with the following variables:
    - WK_DEBUG          Print some extra information for debugging.
                        Any non empty value will turn this on. Default: false

    - WK_CREATE_NOPWD   Don't print the worktree directory after creating it.
                        This will make \`wk\` not cd into the worktree.
                        Any non empty value will turn this on. Default: false

Hooks:
  You can set scripts to run automatically after some actions.
  Set one of the following env variables, pointing to a script, to run them.

  If the variable value is not a script, then it is treated as a bash command
  and runs like this: bash -c "\$WK_ON_<hook>" -- "[<args...>]".
  You can then do something like this:
    WK_ON_CD='p=\$1; n=\$2; tmux rename-window "\$(basename \$n)"' which will be expanded to \`bash -c "p=\$1; n=\$2; tmux rename-window "\$(basename \$n)"" -- "<path>" "<branch>"\`
    Which will result in the tmux window being renamed to the cd'ed worktree branch name.

  - WK_ON_CD        Runs after a \`cd\`.
                    It receives the path of the cd'ed worktree as \$1, and the branch name as \$2.
                    It also received 1 as \$3 if the tree is new, or nothing if it was not.
                    Make sure your script is executable.

Flags:
  --help | -h    show this message
  --force | -f   don't ask for confirmation when removing worktres.
                 can also be turned on by responding "a" (all) on confirmation prompts.
EOF
  if [ "$#" -gt 0 ]; then
    echo
    error "$*"
  fi
  exit 1
}

__git_branch_exists() {
  local remote in_some_remote=0
  git show-ref --verify --quiet refs/heads/"$branch" &>/dev/null && return 0


  while read -r remote; do
    if git fetch --quiet "$remote" "$branch" &>/dev/null; then
      in_some_remote=1
    fi
  done < <(git remote)

  [ "$in_some_remote" = 1 ]
}

_list_trees() {
  local b d

  {
    echo 'Path;Branch;Worktree;Author;Date;Last commit;Branch'
    while read -r p; do
      b="$(git -C "$p" rev-parse --abbrev-ref HEAD)"

      git -C "$p" log -1 --color=never --pretty=format:"$p;$b;$(basename "$p");%an;%ar;%s;$b"
      echo
    done < <(git worktree list | awk '$2 != "(bare)"' | awk '{print $1}')
  } | column -t -s ';'
}

_pretty_list_trees() {
  local b c d repo="${1:-$PWD}" noheadings="$2"
  {
    [ -z "$noheadings" ] && echo 'Worktree;Author;Date;Last commit;Branch'
    while read -r d b; do
      b="$(sed -e 's|\[||' -e 's|\]||' <<< "$b")"
      c="- "
      [ "$PWD" = "$d" ] && c="* "

      git -C "$d" log -1 --color --pretty=format:"%C(3)$(basename "$d");%C(1)%an;%C(6)%ar%C(reset);%s%C(reset);%C(1)${c}%C(10)${b}%C(reset)" | awk -F';' '{if (length($4) > 60) { $4 = substr($4, 0, 59)"..."; } printf "%s;%s;%s;%s;%s;%s;%s", $1, $2, $3, $4, $5, $6, $7; }'
      echo
    done < <(git -C "$1" worktree list | awk '$2 != "(bare)"' | awk '{printf "%s %s\n", $1, $3}')
  } | column -t -s ';'
}

_cleanup_treename() {
  local name="$1" repo
  name="$(sed 's|[ /]|_|g' <<< "$name")"
  echo "$name"
}

_create_tree() {
  local name="$1" tree_name
  tree_name="$(_cleanup_treename "$name")" || exit
  branch="$name"
  path="${_WORKTREES}/$tree_name"

  if __git_branch_exists; then
    git worktree add "$path" "$branch"
  else
    git worktree add "$path" -b "$branch"
  fi
}

_run_hook() {
  local event="$1" args
  shift
  args=( "$@" )
  script="${!event}"
  [ -z "$script" ] && return 0

  if command -v "$script" &>/dev/null; then
    if [ -n "$WK_DEBUG" ]; then
      debug "$event: Running $script ${args[*]}"
    fi
    "$script" "${args[@]}"
  else
    if [ -n "$WK_DEBUG" ]; then
      debug "$event: Running bash -c '${script[*]} -- ${args[*]}'"
    fi
    bash -c "${script[*]}" -- "${args[@]}"
  fi
}

hooks() {
  local action="$1" script args
  shift
  args=( "$@" )

  case "$action" in
    cd)
      _run_hook WK_ON_CD "${args[@]}"
      return
      ;;
  esac
}

action=
action_arg=
force=
while true; do
  [ -z "$1" ] && break

  case "$1" in
    --help|-h|help)
      usage
      ;;

    --force|-f)
      force=1
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
    isnew=
    trees="$(_list_trees)"
    if [ -n "$action_arg" ] && [ ! -d "${_WORKTREES}/$(_cleanup_treename "$action_arg")" ]; then
      info "No worktree found, creating worktree."
      _create_tree "$action_arg" || exit
      isnew=1
    elif [ "$(wc -l <<< "$trees")" -le 1 ]; then
      error "No trees found."
      exit 1
    else
      if [ -n "$action_arg" ] && [ -d "${_WORKTREES}/$(_cleanup_treename "$action_arg")" ]; then
        path="${_WORKTREES}/$(_cleanup_treename "$action_arg")"
        branch="$(_cleanup_treename "$action_arg")"
        info "Switching to $action_arg"
      else
        response="$(echo "$trees" | fzf --no-hscroll --with-nth 3.. --header-lines 1 --ghost "Change worktree" +m)"
        [ -z "$response" ] && exit 1
        name="$(awk '{print $3}' <<< "$response")"
        info "Switching to $name"
        path="$(awk '{print $1}' <<< "$response")"
        branch="$(awk '{print $3}' <<< "$response" | sed -e 's|\[||' -e 's|\]||')"
      fi
    fi

    hooks cd "$path" "$branch" "$isnew"

    if [ -z "$WK_CREATE_NOPWD" ]; then
      echo
      echo "$path"
    fi
    ;;

  list|l|ls)
    check_git
    if [ -f .git ]; then
      repo="$(_common_dir)" || exit
      _pretty_list_trees "$repo"
      exit 0
    fi

    hooks list
    _pretty_list_trees
    ;;

  remove|rm)
    check_git
    original_tree="$(basename "$PWD")"
    should_go_back=
    if [ -f .git ]; then
      repo="$(_common_dir)" || exit
      cd "$repo" || exit
    fi
    trees="$(_list_trees)"
    if [ "$(wc -l <<< "$trees")" -le 1 ]; then
      error "No worktrees found."
      exit 1
    fi

    something_done=
    while read -r path branch tree; do
      [ -z "$tree" ] && continue
      something_done=1

      if [ -z "$force" ]; then
        printf "Deleting %s\nContinue? [N/y/a] " "$tree"
        read -r response < /dev/tty || exit
        if [ "${response,,}" = a ]; then
          force=1
        elif [[ ! "${response,,}" =~ ^y(es)?$ ]]; then
          exit 1
        fi
      fi
      git worktree remove "$path" || exit
      if [ "$tree" = "$original_tree" ]; then
        should_go_back=1
      fi

      if [ -z "$force" ]; then
        printf "Remove branch (%s)? [N/y/a] " "$branch"
        read -r response < /dev/tty
        if [ "${response,,}" = a ]; then
          force=1
        elif [[ ! "${response,,}" =~ ^y(es)?$ ]]; then
          echo
          continue
        fi
      fi

      hooks remove
      git branch -D "$branch" || exit
      echo
    done < <(echo "$trees" | fzf --no-hscroll -m -q "$action_arg" --with-nth 3.. --header-lines 1 --ghost "Remove worktree" | awk '{print $1, $2, $3}' | tee /dev/tty)

    if [ -n "$should_go_back" ]; then
      echo
      _common_dir
    fi
    [ -n "$something_done" ]
    ;;

  *)
    usage "Invalid action: $action"
    ;;
esac
