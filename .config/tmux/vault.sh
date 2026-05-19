#! /usr/bin/env bash

# like ugly.sh but inspired by fallout.

# shellcheck disable=SC2120
usage() {
  cat - <<EOF
Usage:
$ ${0##*/}

Flags:
  --help | -h      show this message
EOF
  if [ "$#" -gt 0 ]; then
    echo
    tput setab 1
    tput setaf 0
    printf " ERROR "
    tput sgr0
    echo " $*"
  fi
  exit 1
}

while true; do
  [ -z "$1" ] && break

  case "$1" in
    --help|-h)
      usage
      ;;
  esac

  shift
done

~/.config/tmux/just-keys.sh || exit
echo
cat - <<EOF
set -g detach-on-destroy no-detached
set -sg escape-time 0
set -g mouse on
set -g renumber-windows on
set -g base-index 1
set -g display-time 0
set -as terminal-overrides 'xterm*:Tc'
set -g status-position top
set -g status-style bg=#040d04,fg=#21bf0f
set -g message-style fg=#040d04,bg=#21bf0f
set -g message-command-style bg=#040d04,fg=#21bf0f
set -g status-left-length 50
set -g status-right-length 50
set -g status-left '#[bg=#{?client_prefix,#21bf0f,#040d04},fg=#{?client_prefix,#040d04,#21bf0f}] #H #[bg=default,fg=default]:: #S   '
set -g status-right '%I:%M %p @ #{pane_current_path} '
set -g window-status-format '#[bg=#040d04,fg=#21bf0f] #I #W #{?window_zoomed_flag,* ,}'
set -g window-status-current-format '#[bg=#21bf0f,fg=#040d04] #I #W #{?window_zoomed_flag,* ,}'
set -g window-status-separator ''
set -g status-justify left
EOF
