#! /usr/bin/env bash

_SHELLS="bash fish sh zsh"

apps_ran=0

while read -r pane; do
  id="$(awk '{print $1}' <<< "$pane")"
  shell="$(awk '{print $2}' <<< "$pane")"
  cwd="$(awk '{print $3}' <<< "$pane")"

  if grep -ivq "$shell" <<< "$_SHELLS"; then
    continue
  fi

  if [ -x "${cwd}/__START__.sh" ]; then
    tmux send-keys -t "$id" ./__START__.sh Enter
    apps_ran=1
  fi
done < <(tmux list-panes -F '#{pane_id} #{pane_current_command} #{pane_current_path}')

[ "$apps_ran" -eq 0 ] && tmux display 'No apps in current window'

true
