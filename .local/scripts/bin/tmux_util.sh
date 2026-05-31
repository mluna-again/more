#! /usr/bin/env bash

_SHELLS=(
  fish
  bash
  sh
  zsh
)

_tmuxp_load_session() {
  local socket="$1" session="$2" session_path="$3" tmp pid lpid code retries found
  [ -z "$session_path" ] && session_path="$session"

  tmp="$(mktemp /tmp/tmux_switch.XXXXXXX)" || return
  tmuxp load -S "$socket" -d "$session_path" &>"$tmp" &
  pid="$!"
  ~/.local/scripts/bin/bunny.sh "loading session..." &
  lpid="$!"
  wait "$pid"
  code="$?"
  kill "$lpid"

  if [ "$code" -ne 0 ]; then
    cat "$tmp"
    rm "$tmp"
    return 1
  fi

  rm "$tmp"

  retries=0
  found=0
  while (( retries < 10 )); do
    if tmux has-session -t "$session" &>/dev/null; then
      found=1
      break
    fi

    retries=$(( retries + 1 ))
    sleep 0.1
  done

  [ "$found" -eq 1 ]
}

client_height_no_bar() {
  local tm h="${1:-1}"
  tm=$(tmux display -p '#{client_height}')
  echo "$(( tm - h ))"
}

client_height() {
  tmux display -p '#{client_height}'
}

panes_count() {
  tmux display -p '#{window_panes}' || return
}

get_last_session_or_default() {
  local current
  current="$(tmux display -p '#{client_last_session}')"
  if [ -z "$current" ]; then
    current="$(get_live_sessions | head -n 1 | awk -F: '{print $1}')"
  fi

  echo "$current"
}

get_saved_sessions() {
  local dir="${1:-$HOME/.local/tmuxp}"

  find -L "$dir" -type f \( -iname '*.yml' -o -iname '*.yaml' \) -a ! -iname '_*' \
    -exec awk '/session_name:/ {s=$2; } /window_name:/ {if ($3 == "") {n=$2} else {n=$3} printf "%s: %s\n", s, n}' {} \; 2>/dev/null
}

get_live_sessions() {
  tmux list-windows -a -F "#{session_name}: #{window_name}" -f '#{!=:#{session_name},quake}'
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

# MARKS
switch_to_session_window_and_pane() {
  local session window pane_index name has_pane
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
  tmux display "#[bg=red,fg=black,fill=red]$*#[fill=default,bg=default]"
}

tmux_info() {
  tmux display "#[bg=yellow,fg=black,fill=yellow]$*#[fill=default,bg=default]"
}

tmux_success() {
  tmux display "#[bg=green,fg=black,fill=green]$*#[fill=default,bg=default]"
}

tmux_fzf_nth() {
  local title h
  title="$1"
  shift
  nth="$1"
  shift

  h=$(printf '%s\n' "$*" | wc -l)
  h=$(( h + 3 )) # margin + header
  termh=$(client_height) || return
  (( (h + 8) >= termh )) && h=$(( termh - 8 ))
  (( h < 8 )) && h=8

  tmux display-popup -h "$h" -w 40 -y S -EE sh -c "printf \"%s\n\" \"$*\" | mina -nth \"$nth\" -title \"$title\" -mode fzf -icon="" >~/.cache/mina_response"
  cat ~/.cache/mina_response
}

tmux_fzf() {
  local title h
  title="$1"
  shift
  h=$(printf '%s\n' "$*" | wc -l)
  h=$(( h + 3 )) # margin + header
  termh=$(client_height) || return
  (( (h + 8) >= termh )) && h=$(( termh - 8 ))
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
  tmux display-popup -h 3 -B -y S -EE sh -c "mina --title=\"$1\" --default=\"$2\" --icon=\"$3\" --mode prompt >~/.cache/mina_response"
  cat ~/.cache/mina_response
}

tmux_prompt() {
  local placeholder="${2:-[N/y]}"
  local y=0
  [ "$(tmux show -v status-position)" = bottom ] && y="$(tmux display -p '#{client_height}')"
  tmux display-popup -h 1 -w 100% -B -y "$y" -EE sh -c "mina --title=\"$1\" --height 1 --mode confirm --onekey --ghost=\"$placeholder\" >~/.cache/mina_response"
  cat ~/.cache/mina_response
}

looks_empty() {
  local shell
  for shell in "${_SHELLS[@]}"; do
    [[  "$shell" = "${1,,}" ]] && return 0
  done

  return 1
}

# Switches TMUX sessions (supports tmuxp sessions (lazy))
tmux_switch() {
  local session="$1" window="$2" socket retries output res code pid lpid tmp tmp2 window_exists session_file random_name index
  window_exists="$(tmux list-windows -t "$session" -F '#{window_name}' 2>/dev/null | grep -x "$window")"
  if [ -z "$window_exists" ]; then
    socket=$(tmux display -p '#{socket_path}')
    if ! tmux has-session -t "$session" &>/dev/null; then
      if ! command -v tmuxp &>/dev/null; then
        tmux_alert "No tmuxp installed, and session/window is lazy loaded!"
        return 1
      fi
      _tmuxp_load_session "$socket" "$session" || return
    elif [ -n "$window" ]; then
      if ! command -v yq &>/dev/null; then
        tmux_alert "Window is lazy loaded but yq is not installed"
        return 1
      fi
      
      session_file="$HOME/.local/tmuxp/${session}.yaml"
      [ ! -f "$session_file" ] && session_file="$HOME/.local/tmuxp/${session}.yml"
      if [ ! -f "$session_file" ]; then
        tmux_alert "No config file found for $session"
        return 1
      fi

      tmp="$(mktemp /tmp/tmux_switch.XXXXXX.yaml)" || return
      tmp2="$(mktemp /tmp/tmux_switch.XXXXXX.yaml)" || return
      index="$(grep window_name: "$session_file" | awk "\$3 == \"$window\" {i=NR} END {print i}")"
      index="${index:-1}"
      yq ".windows[] | select(.window_name == \"$window\")" "$session_file" > "$tmp2"
      random_name="$(basename "$tmp")"
      random_name="$(sed 's|\.|_|g' <<< "$random_name")"
      yq -n ".session_name=\"$random_name\" | .windows[0] = load(\"$tmp2\")" > "$tmp" || return
      _tmuxp_load_session "$socket" "$random_name" "$tmp" || return
      tmux move-window -b -s "$random_name:1" -t "$session:$index" || return
      rm "$tmp"
      rm "$tmp2"
    fi
  fi

  output=$(tmux switch-client -t "$session" \; select-window -t "$window" 2>&1)
  res="$?"
  if [ "$res" -ne 0 ]; then
    tmux_alert "$output"
  fi
}
