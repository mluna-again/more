#! /usr/bin/env bash

source ~/.local/scripts/bin/tmux_util.sh || exit

files=$(find -L ~/.local/tmuxp -type f -exec awk '/session_name:/ {s=$2; } /window_name:/ {printf "%s: %s\n", s, $3}' {} \;)
if [ -z "$files" ]; then
  tmux_alert "No session files in ~/.local/tmuxp"
  exit
fi

sessions_without_config=$(
  tmux list-sessions -F "#{session_name}: #{window_name}" | \
    grep -v "$files"
)
output=$(
    echo -e "${files}\n${sessions_without_config}" | \
    grep -v quake | \
    sort -h | \
    mina -title="Search a TMUX session" -icon=""
)

[ -z "$output" ] && exit

session=$(awk -F: '{print $1}' <<< "$output" | xargs)
window=$(awk -F: '{print $2}' <<< "$output" | xargs)

[ -z "$session" ] && exit
[ -z "$window" ] && exit

if ! tmux has-session -t "$session" &>/dev/null; then
  tmuxp load -d "$session" || exit
fi

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
