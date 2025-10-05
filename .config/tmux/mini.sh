#! /usr/bin/env bash

# This prints a copy of ~/.tmux.conf
# to STDOUT but replacing some custom functionality for a simpler but dependency free alternative, when possible.

sed -e 's|\(.*plugins/tpm/tpm.*\)|# \1|g' \
  -e 's|run-shell .*rename_session.sh.*$|command-prompt -p "Rename session:" "rename-session -t . '%%'"|g' \
  -e 's|run-shell .*search_backwards.sh.*$|command-prompt -T search -p "(search up)" { send-keys -X search-backward "%%" }|g ' \
  -e 's|run-shell .*search_forwards.sh.*$|command-prompt -T search -p "(search down)" { send-keys -X search-forward "%%" }|g ' \
  -e 's|run-shell .*rename_window.*$|command-prompt -p "Rename window:" "rename-window -t . %%"|g ' \
  -e 's|^bind.*run-shell .*resize.sh.*$|bind Left resize-pane -t . -L 5\nbind Right resize-pane -t . -R 5\nbind Up resize-pane -t . -U 5\nbind Down resize-pane -t . -D 5|g ' \
  -e 's|run-shell .*reload.sh.*$|source-file ~/.tmux.conf \\; display-message "Config reloaded"|g ' \
  -e 's|display-popup .*switch_session.sh.*$|choose-tree|g ' \
  ~/.tmux.conf | \
  awk '{
    if ($0 ~ /run-shell/) {
      msg = sprintf("display-message \"%s not implemented\"\n", $4);
      gsub(/run-shell .*/, msg, $0);
      printf $0;
    } else {
      print $0;
    }
  }'
