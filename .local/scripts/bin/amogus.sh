#! /usr/bin/env bash

path="$HOME/.local/non_ascii/amogus.gif"

clear
# this one needs a little bit to catch up with the window size changing
sleep 1
chafa "$path" --center true --animate off --colors none | nms -a && chafa "$path" --center true
