#! /usr/bin/env bash

# SPOTIFY (BOP) INSTRUCTIONS
# Clone shinobu and follow the instructions below:
# https://github.com/mluna-again/shinobu/tree/master/.local/scripts/bop

id=$(docker container ls | awk '$0 ~ "bop-server" { print $1 }')
if [ -z "$id" ]; then
  tmux display-message -d 0 "could not find bop, is it running? (check tmux_spotify.sh for details)"
  exit 0
fi

options="'Player' m 'display-popup -w 95% -h 95% -y S -EE docker container exec -it $id bop tui player'"
options="${options} 'Selector' s 'display-popup -w 95% -h 95% -y S -EE docker container exec -it $id bop tui select'"
options="${options} 'Queue' Q 'display-popup -w 95% -h 95% -y S -EE docker container exec -it $id bop tui queue'"
eval tmux display-menu -T " Runner " -x C -y "10%" "$options"
