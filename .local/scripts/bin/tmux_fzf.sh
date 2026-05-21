#! /usr/bin/env bash

die() {
  echo "$*" 1>&2
  exit 1
}

if ! command -v fzf &>/dev/null; then
  die no fzf installed
fi

# hardcoded tmux_util.sh functions so this script is self-contained
get_saved_sessions() {
  local dir="${1:-$HOME/.local/tmuxp}"

  find -L "$dir" -type f \( -iname '*.yml' -o -iname '*.yaml' \) -a ! -iname '_*' \
    -exec awk '/session_name:/ {s=$2; } /window_name:/ {if ($3 == "") {n=$2} else {n=$3} printf "%s: %s\n", s, n}' {} \; 2>/dev/null
}

get_live_sessions() {
  tmux list-windows -a -F "#{session_name}: #{window_name}"
}

get_sessions() {
  local saved live saved_but_not_loaded with_label="${1:-0}"

  saved="$(get_saved_sessions)"
  live="$(get_live_sessions)"
  if [ -n "$saved" ]; then
    if [ "$with_label" -eq 1 ]; then
      saved_but_not_loaded="$(grep -vx "$live" <<< "$saved" | awk '{printf "%s (lazy)\n", $0}')"
    else
      saved_but_not_loaded="$(grep -vx "$live" <<< "$saved")"
    fi
    printf "%s\n%s\n" "$live" "$saved_but_not_loaded" | sort -h | grep -Ev '^\s*$'
  else
    echo "$live" | sort -h | grep -Ev '^\s*$'
  fi
}

_switch() {
  local session="$1" window="$2" session_created socket retries output res
  session_created=0
  if ! tmux has-session -t "$session" &>/dev/null; then
    if ! command -v tmuxp &>/dev/null; then
      tmux display "No tmuxp installed, and session is lazy loaded!"
      return 1
    fi
    session_created=1
    socket=$(tmux display -p '#{socket_path}')
    tmuxp load -S "$socket" -d "$session" || exit
  fi

  if [ "$session_created" -eq 1 ]; then
    retries=0
    while (( retries < 10 )); do
      output=$(tmux switch-client -t "$session" \; select-window -t "$window" 2>&1)
      res="$?"
      [ "$res" -eq 0 ] && break

      if [ "$res" -ne 0 ] && (( retries >= 9 )); then
        echo "$output"
        break
      fi

      retries=$(( retries + 1 ))
      sleep 0.1
    done
  else
    output=$(tmux switch-client -t "$session" \; select-window -t "$window" 2>&1)
    res="$?"
    if [ "$res" -ne 0 ]; then
      tmux display "$output"
    fi
  fi
}

output="$(get_sessions 1 | fzf +m --border=none)"
[ -z "$output" ] && exit 0
session="$(awk -F: '{print $1}' <<< "$output" | xargs)"
window="$(awk -F: '{print $2}' <<< "$output" | xargs)"
[ -z "$session" ] && exit 1
[ -z "$window" ] && exit 1

_switch "$session" "$window"
