#! /usr/bin/env bash

# what is this? some questions are better unanswered

# shellcheck disable=SC2120
usage() {
  cat - <<EOF
Usage:
$ ${0##*/} <accent color>
$ ${0##*/} magenta
$ ${0##*/} red

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

color=
while true; do
  [ -z "$1" ] && break

  case "$1" in
    --help|-h)
      usage
      ;;

    *)
      color="$1"
      ;;
  esac

  shift
done

[ -z "$color" ] && usage missing color

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
set -g status-style bg=$color,fg=black
set -g message-style fg=$color,bg=black
set -g status-left-length 50
set -g status-right-length 50
set -g status-left '#[bg=#{?client_prefix,black,$color},fg=#{?client_prefix,white,black}] #H #[bg=default,fg=default]:: #S '
set -g status-right '%I:%M %p @ #{pane_current_path} '
set -g window-status-format '#[bg=$color,fg=black] #I #W #{?window_zoomed_flag,* ,}'
set -g window-status-current-format '#[bg=black,fg=white] #I #W #{?window_zoomed_flag,* ,}'
set -g window-status-separator ''
set -g status-justify absolute-centre
set -ga command-alias killsess="kill-session"
EOF
