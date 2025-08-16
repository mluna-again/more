#! /usr/bin/env bash

die() {
  tmux display "$1"
  exit 1
}

goto_top_pane() {
  count=0
  while [[ "$(tmux display -p -F '#{pane_at_top}')" != 1 ]]; do
    tmux select-pane -U || die "Failed at select-pane -U"
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
    tmux select-pane -D || die "Failed at select-pane -D"
    if (( count > 5 )); then
      tmux display "Ok. Something is wrong, can't find bottom pane. Aborting."
      break
    fi
    count=$(( count + 1 ))
  done
}

current_pane=$(tmux list-panes -F '#{pane_active} #{pane_id}' | awk '$1 == "1" {print $2}') || die "Failed at \$current_pane"
first_pane=$(tmux list-panes -F '#{pane_at_top} #{pane_at_left} #{pane_id}' | awk '$0 ~ /1 1.*/ {print $3}') || die "Failed at \$first_pane"
pane_count=$(tmux list-panes | wc -l) || die "Failed at \$pane_coun"

if (( pane_count != 1 )) && (( pane_count != 5 )); then
  tmux display-message "This command only works on windows with 1 or 5 panes."
  exit 0
fi

if (( pane_count == 1 )); then
  tmux split-window -h -l "30%" || die "Failed at split-window -h -l '30%'"
  tmux split-window -v -l "50%" || die "Failed at split-window -v -l '50%'"
  tmux split-window -v -l "50%" || die "Failed at split-window -v -l '50%'"
  tmux select-pane -t "$current_pane" || die "Failed at select-pane -t \$current_pane"
  tmux split-window -v -l "25%" || die "Failed at split-window -v -l '25%'"
  tmux select-pane -t "$current_pane" || die "Failed at select-pane -t \$current_pane"

  exit 0
fi

# this is gonna break every 5 minutes i just know it
tmux swap-pane -s "$current_pane" -t "$first_pane" || die "Failed at swap-pane -s \$current_pane -t \$first_pane" 
tmux select-pane -t "$current_pane" || die "Failed at select-pane -t \$current_pane"
tmux select-layout main-vertical || die "Failed at select-layout main-vertical"
tmux resize-pane -t . -x "80%" || die "Failed at resize-pane -t . -x '80%'"
tmux select-pane -R || die "Failed at select-pane -R"
goto_top_pane
tmux join-pane -s . -t "$current_pane" -l "25%" || die "Failed at join-pane -s . -t \$current_pane -l '25%'"
tmux select-pane -R || die "Failed at select-pane -R"
goto_top_pane
tmux resize-pane -t . -y "50%" || die "Failed at resize-pane -t . -y '50%'"
tmux select-pane -D || die "Failed at select-pane -D"
tmux resize-pane -t . -y "25%" || die "Failed at resize-pane -t . -y '25%'"
tmux select-pane -D || die "Failed at select-pane -D"
tmux resize-pane -t . -y "25%" || die "Failed at resize-pane -t . -y '25%'"
tmux select-pane -t "$current_pane" || die "Failed at select-pane -t \$current_pane"
