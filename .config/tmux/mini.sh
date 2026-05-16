#! /usr/bin/env bash

# This prints a copy of ~/.tmux.conf
# to STDOUT but replacing some custom functionality for a simpler but dependency free alternative, when possible.

sed -e 's|\(.*plugins/tpm/tpm.*\)|# \1|g' \
  -e 's|run-shell .*rename_session.sh.*$|command-prompt -p "Rename session:" "rename-session -t . '\''%%'\''"|g' \
  -e 's|run-shell .*search_backwards.sh.*$|command-prompt -T search -p "(search up)" { send-keys -X search-backward '\''%%'\'' }|g ' \
  -e 's|run-shell .*search_forwards.sh.*$|command-prompt -T search -p "(search down)" { send-keys -X search-forward '\''%%'\'' }|g ' \
  -e 's|run-shell .*rename_window.*$|command-prompt -p "Rename window:" "rename-window -t . '\''%%'\''"|g ' \
  -e 's|run-shell .*session_new.sh.*$|command-prompt -p "New session:" "new-session -c ~ -s '\''%%'\''"|g ' \
  -e 's|display.* .*switch_session.sh.*$|display-popup -h 10 -y S -EE ~/.local/bin/tmux_fzf.sh|g ' \
  -e 's|run-shell .*balance.sh.*$|select-layout -E|g ' \
  -e 's|^bind.*run-shell .*resize.sh.*$|bind Left resize-pane -t . -L 5\nbind Right resize-pane -t . -R 5\nbind Up resize-pane -t . -U 5\nbind Down resize-pane -t . -D 5|g ' \
  -e 's|run-shell .*reload.sh.*$|source-file ~/.tmux.conf \\; display-message "Config reloaded"|g ' \
  ~/.tmux.conf | \
  awk '{
    if ($0 ~ /tmux_fzf.sh/) {
      print $0;
    } else if ($0 ~ /run-shell/) {
      msg = sprintf("display-message \"%s not implemented\"\n", $4);
      gsub(/run-shell .*/, msg, $0);
      printf $0;
    } else if($0 ~ /display-popup/) {
      msg = sprintf("display-message \"%s not implemented\"\n", $NF);
      gsub(/display-popup .*/, msg, $0);
      printf $0;
    }
    else {
      print $0;
    }
  }'
