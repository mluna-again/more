#! /usr/bin/env bash

source ~/.local/scripts/bin/tmux_util.sh || exit

SCRIPTS_DIR="$HOME/.local/bin/scripts"

scripts=$(find "$SCRIPTS_DIR" -executable -iname "*_tmux.sh" -print0 | xargs -0 -I{} basename {})
scripts_count=$(find "$SCRIPTS_DIR" -executable -iname "*_tmux.sh" | wc -l)
if (( scripts_count <= 0 )); then
  tmux_alert "No executable files ending in \`_tmux.sh\` found in ~/.local/bin/scripts"
  exit
fi


selected=$(tmux_fzf " Scripts " "$scripts") || exit
[ -z "$selected" ] && exit

bg="$(tmux display -p '#{@black2}')"
tmux display-popup -EE -s bg="${bg:-gray}" "$SCRIPTS_DIR/$selected"

true
