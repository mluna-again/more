#! /usr/bin/env bash

source ~/.local/scripts/bin/tmux_util.sh || exit

SCRIPTS_DIR="$HOME/.local/bin/scripts"

scripts=$(find "$SCRIPTS_DIR" -executable -iname "*_tmux.sh" | xargs -I{} basename {})
scripts_count=$(find "$SCRIPTS_DIR" -executable -iname "*_tmux.sh" | wc -l)
if (( scripts_count <= 0 )); then
  tmux_alert "No executable files ending in \`_tmux.sh\` found in ~/.local/bin/scripts"
  exit
fi


selected=$(tmux_fzf " Scripts " "$scripts") || exit
[ -z "$selected" ] && exit

tmux display-popup -EE "$SCRIPTS_DIR/$selected"

true
