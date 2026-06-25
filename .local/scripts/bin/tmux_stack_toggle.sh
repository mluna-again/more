#! /usr/bin/env bash

source ~/.local/scripts/bin/tmux_util.sh || exit

stack() {
  read -r right left < <(tmux display -p '#{pane_at_right} #{pane_at_left}')
  if [ "$right" -eq 1 ]; then
    tmux set-option -w @stack_at_right 1
  elif [ "$left" -eq 1 ]; then
    tmux set-option -w @stack_at_left 1
  else
    tmux_alert "Only panes on the right/left can be stacked."
    return
  fi
  # shellcheck disable=SC2088
  tmux bind k run-shell '~/.local/scripts/bin/tmux_stack.sh k'
  # shellcheck disable=SC2088
  tmux bind j run-shell '~/.local/scripts/bin/tmux_stack.sh j'
  # shellcheck disable=SC2088
  tmux bind C-k run-shell '~/.local/scripts/bin/tmux_stack.sh k'
  # shellcheck disable=SC2088
  tmux bind C-j run-shell '~/.local/scripts/bin/tmux_stack.sh j'
  tmux run-shell '~/.local/scripts/bin/tmux_stack.sh STAY'
}

unstack() {
  read -r right left < <(tmux display -p '#{pane_at_right} #{pane_at_left}')
  if [ "$right" -eq 1 ]; then
    tmux set-option -wu @stack_at_right
  elif [ "$left" -eq 1 ]; then
    tmux set-option -wu @stack_at_left
  else
    tmux_alert "Only panes on the right/left can be stacked."
    return
  fi
  read -r sright < <(tmux display -p '#{@stack_at_right}')
  read -r sleft < <(tmux display -p '#{@stack_at_left}')
  if [ -z "$sright" ] && [ -z "$sleft" ]; then
    tmux bind k select-pane -U -Z
    tmux bind j select-pane -D -Z
    tmux bind C-k select-pane -U -Z
    tmux bind C-j select-pane -D -Z
  fi
  tmux resize-pane -y 50%
}

read -r sright < <(tmux display -p '#{@stack_at_right}')
read -r sleft < <(tmux display -p '#{@stack_at_left}')
read -r right left < <(tmux display -p '#{pane_at_right} #{pane_at_left}')

if [ "$right" -eq 1 ]; then
  if [ "$sright" -eq 1 ]; then
    unstack
  else
    stack
  fi
elif [ "$left" -eq 1 ]; then
  if [ "$sleft" -eq 1 ]; then
    unstack
  else
    stack
  fi
else
  tmux_alert "Only panes on the right/left can be stacked."
  exit 0
fi
