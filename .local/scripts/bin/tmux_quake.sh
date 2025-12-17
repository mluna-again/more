#! /usr/bin/env bash

configure_quake_session() {
  tmux new-session -c ~ -d -s quake 2>/dev/null
  tmux set-option -s -t quake key-table popup
  tmux set-option -s -t quake prefix C-b
  tmux set-option -t quake status off

  # disables C-x as prefix so it doesnt do weird stuff but keeps the same (C-x C-x) binging to toggle the popup.
  # no idea how this witchcraft works, i didnt even know making multi-key bindings was possible
  # the syntax is pretty weird tho, i took this from `man tmux` btw.
  # no idea what switch-client does here but it was in the manual's example and it works ¯\_(ツ)_/¯
  tmux bind -Tpopup2 C-x detach
  tmux bind -Tpopup C-x switch-client -Tpopup2

  # prevents weird state when exiting session the normal way, you can still mess up typing `exit` but i never do that.
  tmux bind -Tpopup C-d send-keys "# use C-x C-x to exit this :)"
}

configure_quake_session

tmux display-popup -y 0 -w 100% -h 50% -E "tmux attach -t quake"
