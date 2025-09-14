#! /usr/bin/env bash

source ~/.local/scripts/bin/tmux_util.sh || exit

# SPOTIFY (BOP) INSTRUCTIONS
# Clone shinobu and follow the instructions below:
# https://github.com/mluna-again/shinobu/tree/master/.local/scripts/bop

# bop is tired :(
# id=$(docker container ls | awk '$0 ~ "bop-server" { print $1 }')
# if [ -z "$id" ]; then
#   tmux display-message -d 0 "could not find bop, is it running? (check tmux_spotify.sh for details)"
#   exit 0
# fi
#
# options="'Player' m 'display-popup -w 95% -h 95% -y S -EE docker container exec -it $id bop tui player'"
# options="${options} 'Selector' s 'display-popup -w 95% -h 95% -y S -EE docker container exec -it $id bop tui select'"
# options="${options} 'Queue' q 'display-popup -w 95% -h 95% -y S -EE docker container exec -it $id bop tui queue'"
# eval tmux display-menu -T " Runner " -x C -y "10%" "$options"

# cargo install spotify_player --features image,fzf
if ! command -v spotify_player &>/dev/null; then
  tmux display-message "spotify_player is not installed. Remember to run spotify_player authenticate afterwards."
  exit 0
fi

# use a window named "music" instead of a popup, to reduce startup time
original_win=$(tmux display -p '#{window_id}')
while read -r win_id win_name; do
  [ "$win_name" != music ] && continue

  tmux select-window -t "$win_id" || exit
  read -r pane_id pane_cmd < <(tmux list-panes -t "$win_id" -F '#{pane_id} #{pane_current_command}' | head -1) || exit

  if [ "$original_win" = "$win_id" ] && [ "$pane_cmd" = spotify_player ]; then
    tmux select-window -l
    exit 0
  fi

  if ! looks_empty "$pane_cmd"; then
    if [ "$pane_cmd" != spotify_player ]; then
      tmux display "Other program is running in current window. Or multiple panes open."
      exit 0
    fi

    exit 0
  fi

  tmux send-keys -t "$pane_id" spotify_player Enter || exit

  exit 0
done < <(tmux list-windows -F '#{window_id} #{window_name}')

tmux display-popup -w 95% -h 95% -y S -EE spotify_player

true
