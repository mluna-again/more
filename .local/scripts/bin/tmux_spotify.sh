#! /usr/bin/env bash

# SPOTIFY (BOP) INSTRUCTIONS
# Clone shinobu and follow the instructions below:
# https://github.com/mluna-again/shinobu/tree/master/.local/scripts/bop

id=$(docker container ls | awk '$0 ~ "bop-server" { print $1 }')
if [ -z "$id" ]; then
  tmux display-message -d 0 "could not find bop, is it running? (check tmux_spotify.sh for details)"
  exit 0
fi

docker container exec -it "$id" bop tui player
