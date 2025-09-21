#! /usr/bin/env bash

source ~/.local/scripts/bin/tmux_util.sh || exit

_TSESSION=music
_TMUSICPLAYER=spotify_player

# cargo install spotify_player --features image,fzf
if ! command -v "$_TMUSICPLAYER" &>/dev/null; then
  tmux display-message "$_TMUSICPLAYER is not installed. Remember to run $_TMUSICPLAYER authenticate afterwards."
  exit 0
fi

current_session=$(tmux display -p '#{session_name}') || exit

if ! tmux switch-client -t "$_TSESSION"; then
  tmux new-session -d -c ~ -n "$_TSESSION" -s "$_TMUSICPLAYER" "$_TMUSICPLAYER"
  tmux switch-client -t todo
  exit 0
fi

read -r pane cmd < <(tmux display -p '#{pane_id} #{pane_current_command}' | head -1) || exit

if [ "$current_session" = "$_TSESSION" ] && [ "$cmd" = "$_TMUSICPLAYER" ]; then
  tmux switch-client -l
  exit 0
fi

pane_count=$(tmux list-panes -t todo | wc -l)
if (( pane_count > 1 )); then
  tmux display "More than one pane open."
  exit 0
fi

if ! looks_empty "$cmd"; then
  if [ "$cmd" != "$_TMUSICPLAYER" ]; then
    tmux display "Another program running."
    exit 0
  fi

  exit 0
fi

tmux send-keys -t "$pane" "$_TMUSICPLAYER" Enter
