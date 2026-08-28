#! /usr/bin/env bash

if [ -z "$1" ]; then
  tmux set-option -wu @window_msg
  tmux set-option -wu @window_msg_styles
  tmux set-option -wu @window_msg_current_styles
else
  case "${1,,}" in
    blocked)
      tmux set-option -w @window_msg_styles ",bg=black,fg=red"
      tmux set-option -w @window_msg_current_styles ",bg=red,fg=black"
      tmux set-option -w @window_msg " "
      ;;
    done)
      tmux set-option -w @window_msg_styles ",bg=black,fg=green"
      tmux set-option -w @window_msg_current_styles ",bg=green,fg=black"
      tmux set-option -w @window_msg " "
      ;;
    wip)
      tmux set-option -w @window_msg_styles ",bg=black,fg=colour13"
      tmux set-option -w @window_msg_current_styles ",bg=colour13,fg=black"
      tmux set-option -w @window_msg " "
      ;;
    todo)
      tmux set-option -w @window_msg_styles ",bg=black,fg=colour242"
      tmux set-option -w @window_msg_current_styles ",bg=colour242,fg=white"
      tmux set-option -w @window_msg " "
      ;;
    draft)
      tmux set-option -w @window_msg_styles ",bg=black,fg=cyan"
      tmux set-option -w @window_msg_current_styles ",bg=cyan,fg=black"
      tmux set-option -w @window_msg "󰟶 "
      ;;
    review)
      tmux set-option -w @window_msg_styles ",bg=black,fg=yellow"
      tmux set-option -w @window_msg_current_styles ",bg=yellow,fg=black"
      tmux set-option -w @window_msg " "
      ;;
    ready)
      tmux set-option -w @window_msg_styles ",bg=black,fg=colour23"
      tmux set-option -w @window_msg_current_styles ",bg=colour23,fg=white"
      tmux set-option -w @window_msg " "
      ;;
  esac
fi
