#! /usr/bin/env bash

# same as mini.sh but "tailored" for servers.
# and by tailored i mean it just displays uptime in the status bar

~/.config/tmux/mini.sh | \
  sed -e 's|status-right "\(.*\)"|status-right "#(uptime --pretty) \1"|g' \
  -e "s|status-right '\(.*\)'|status-right \"#(uptime --pretty) \1\"|g"
