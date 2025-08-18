#! /usr/bin/env bash

missing_deps=""

command -v chafa &>/dev/null || missing_deps="chafa ${missing_deps}"
command -v nms &>/dev/null || missing_deps="nms ${missing_deps}"
command -v docker &>/dev/null || missing_deps="docker ${missing_deps}"
command -v luna &>/dev/null || missing_deps="luna ${missing_deps}"
command -v cava &>/dev/null || missing_deps="cava ${missing_deps}"

if [ -n "$missing_deps" ]; then
  tmux display "Missing deps: ${missing_deps}"
  exit 0
fi

_SHELLS=(
  fish
  bash
  sh
  zsh
  nvim # i this this is not a shell
)

looks_empty() {
  for shell in "${_SHELLS[@]}"; do
    grep -iq "$shell" <<< "$1" && return 0
  done

  return 1
}

neovim_count=0
while read -r pane; do
  cmd=$(awk '{print $1}' <<< "$pane")
  id=$(awk '{print $2}' <<< "$pane")
  if ! looks_empty "$cmd"; then
    tmux display "Not all panes are empty. Bye."
    exit 0
  fi

  if [ "$cmd" = nvim ]; then
    tmux select-pane -t "$id"
    neovim_count=$(( neovim_count + 1 ))
  fi
done < <(tmux list-panes -F '#{pane_current_command} #{pane_id}')

if (( neovim_count > 1 )); then
  tmux display "More than one neovim instance detected. Bye."
  exit 0
fi

if (( neovim_count < 1 )); then
  tmux display "You don't have a neovim instance running. Bye."
  exit 0
fi

output=$(~/.local/scripts/bin/tmux_matrix.sh) || exit
[ -n "$output" ] && exit 0

index=0
while read -r pane; do
  cmd=$(awk '{print $1}' <<< "$pane")
  id=$(awk '{print $2}' <<< "$pane")

  [ "$cmd" = nvim ] && continue

  tmux send-keys -t "$id" C-l

  case "$index" in
    0)
      tmux send-keys -t "$id" cava Enter
      ;;
    1)
      tmux send-keys -t "$id" ~/.local/scripts/bin/rain.sh Enter
      ;;
    2)
      tmux send-keys -t "$id" luna Space -pet Space cat Space -animation Space sleeping Enter
      ;;
    3)
      tmux send-keys -t "$id" ~/.local/scripts/bin/amogus.sh Enter
      ;;
  esac

  index=$(( index + 1 ))
done < <(tmux list-panes -F '#{pane_current_command} #{pane_id}')
