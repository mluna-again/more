#! /usr/bin/env bash

_SHELLS=(
  fish
  bash
  sh
  zsh
)

get_sessions() {
  files=$(find -L ~/.local/tmuxp -type f -exec awk '/session_name:/ {s=$2; } /window_name:/ {if ($3 == "") {n=$2} else {n=$3} printf "%s: %s\n", s, n}' {} \; 2>/dev/null)
  sessions_without_config=$(tmux list-windows -a -F "#{session_name}: #{window_name}")
  [ -n "$files" ] && sessions_without_config=$(grep -v "$files" <<< "$sessions_without_config")

  echo -e "${files}\n${sessions_without_config}"
}

# MARKS
switch_to_session_window_and_pane() {
  local session window pane_index name has_session has_window has_pane
  session="$1"
  window="$2"
  pane="$3"
  name="$4"

  has_pane=$(tmux list-panes -a -F "#{session_name} #{window_name} #{pane_index}" | grep -q "$session $window $pane_index" && echo 1)

  if [ "$has_pane" -eq 1 ]; then
    tmux switch-client -t "$session" || return
    tmux select-window -t "$window" || return
    tmux select-pane -t "$pane" || return
  else
    tmux_alert "No mark found: $name"
    return 1
  fi

  return 0
}

unmark_pane() {
  local session window pane_index name pane_id
  session="$1"
  window="$2"
  pane_index="$3"
  name="$4"

  pane_id=$(tmux list-panes -a -F "#{session_name} #{window_name} #{pane_index} #{pane_id}" | grep "$session $window $pane_index .*" | awk '{print $4}') || return 1
  [ -z "$pane_id" ] && return 0

  new_name=$(sed 's|^M: ||g' <<< "$name")
  tmux select-pane -t "$pane_id" -T "$new_name"
}

unmark_all() {
  local pane_id name
  while read -r pane_id name; do
    new_name=$(sed 's|^M: ||g' <<< "$name")
    tmux select-pane -t "$pane_id" -T "$new_name"
  done < <(tmux list-panes -a -F '#{pane_id} #{pane_title}' -f '#{m/r:^M: ,#{pane_title}}')
}

mark_pane_if_not_already() {
  local current
  current=$(tmux display -p "#{pane_title}") || return
  if grep -iq "^M: " <<< "$current"; then
    return 0
  fi
  tmux select-pane -T "M: #{pane_title}"
}
# MARKS

tmux_alert() {
  tmux display "$*"
}

tmux_fzf_nth() {
  local title h
  title="$1"
  shift
  nth="$1"
  shift

  h=$(printf '%s\n' "$*" | wc -l)
  h=$(( h + 3 )) # margin + header
  termh=$(tput lines) || return
  (( (h - 10) >= termh )) && h=$(( termh - 8 ))
  (( h < 8 )) && h=8

  tmux display-popup -h "$h" -w 40 -y S -EE sh -c "printf \"%s\n\" \"$*\" | mina -nth "$nth" -title \"$title\" -mode fzf -icon="" >~/.cache/mina_response"
  cat ~/.cache/mina_response
}

tmux_fzf() {
  local title h
  title="$1"
  shift
  h=$(printf '%s\n' "$*" | wc -l)
  h=$(( h + 3 )) # margin + header
  termh=$(tput lines) || return
  (( (h - 10) >= termh )) && h=$(( termh - 8 ))
  (( h < 8 )) && h=8

  tmux display-popup -h "$h" -w 40 -y S -EE sh -c "printf \"%s\n\" \"$*\" | mina -title \"$title\" -mode fzf -icon="" >~/.cache/mina_response"
  cat ~/.cache/mina_response
}

tmux_menu() {
  local title h
  title="$1"
  shift

  h=$(printf '%s\n' "$*" | wc -l)
  h=$(( h + 3 )) # margin + header
  termh=$(tput lines) || return
  (( (h - 10) >= termh )) && h=$(( termh - 8 ))
  (( h < 8 )) && h=8

  tmux display-popup -h "$h" -w 40 -y S -EE sh -c "printf \"%s\n\" \"$*\" | mina -sep @ -title \"$title\" -mode menu >~/.cache/mina_response"
  cat ~/.cache/mina_response
}

tmux_ask() {
  tmux display-popup -h 3 -B -y 5% -EE sh -c "mina --title=\"$1\" --default=\"$2\" --icon=\"$3\" --mode prompt >~/.cache/mina_response"
  cat ~/.cache/mina_response
}

tmux_prompt() {
  tmux display-popup -h 1 -w 100% -B -y 0 -EE sh -c "mina --title=\"$1\" --height 1 --mode confirm --onekey >~/.cache/mina_response"
  cat ~/.cache/mina_response
}

looks_empty() {
  local shell
  for shell in "${_SHELLS[@]}"; do
    [[  "$shell" =~ ${1,,} ]] && return 0
  done

  return 1
}
