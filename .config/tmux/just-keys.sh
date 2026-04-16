#! /usr/bin/env bash

# This prints a copy of ~/.tmux.conf
# to STDOUT but only the config related to keybinds.
# Removes non-native functionality (just as in mini.sh)

~/.config/tmux/mini.sh | \
  grep -E -e '^bind' -e '^unbind' | \
  grep -v '.* not implemented'
