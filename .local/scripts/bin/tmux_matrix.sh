#! /usr/bin/env bash

goto_top_pane() {
  count=0
  while [[ "$(tmux display -p -F '#{pane_at_top}')" != 1 ]]; do
    tmux select-pane -U || exit
    if (( count > 5 )); then
      tmux display "Ok. Something is wrong, can't find top pane. Aborting."
      break
    fi
    count=$(( count + 1 ))
  done
}

goto_bottom_pane() {
  count=0
  while [[ "$(tmux display -p -F '#{pane_at_bottom}')" != 1 ]]; do
    tmux select-pane -D || exit
    if (( count > 5 )); then
      tmux display "Ok. Something is wrong, can't find bottom pane. Aborting."
      break
    fi
    count=$(( count + 1 ))
  done
}

current_pane=$(tmux list-panes -F '#{pane_active} #{pane_id}' | awk '$1 == "1" {print $2}') || exit
first_pane=$(tmux list-panes -F '#{pane_id}' | awk 'NR==1') || exit
pane_count=$(tmux list-panes | wc -l) || exit

if (( pane_count != 1 )) && (( pane_count != 5 )); then
  tmux display-message "This command only works on windows with 1 or 5 panes."
  exit 0
fi

if (( pane_count == 1 )); then
  tmux split-window -h -l "30%" || exit
  tmux split-window -v -l "50%" || exit
  tmux split-window -v -l "50%" || exit
  tmux select-pane -t "$current_pane" || exit
  tmux split-window -v -l "25%" || exit
  tmux select-pane -t "$current_pane" || exit

  exit 0
fi

# this is gonna break every 5 minutes i just know it
tmux select-pane -t "$first_pane" || exit 
tmux select-layout main-vertical || exit
tmux resize-pane -t . -x "80%" || exit
tmux select-pane -R || exit
goto_top_pane
tmux join-pane -s . -t "$first_pane" -l "25%" || exit
tmux select-pane -R || exit
goto_top_pane
tmux resize-pane -t . -y "50%" || exit
tmux select-pane -D || exit
tmux resize-pane -t . -y "25%" || exit
tmux select-pane -D || exit
tmux resize-pane -t . -y "25%" || exit
tmux select-pane -t "$first_pane" || exit
