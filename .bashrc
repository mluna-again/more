 # shellcheck shell=bash

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

PATH="$HOME/go/bin:$HOME/.local/bin:$PATH"
export PATH

export EDITOR=nvim

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

hostc="$(tput setaf 1)"
red="$(tput setaf 1)"
gray="$(tput setaf 5)"
green="$(tput setaf 2)"
yellow="$(tput setaf 3)"
reset="$(tput sgr0)"
__status_ps1() {
  local e="$?"
  [ "$e" -ne 0 ] && printf "%s%s%s " "$red" "$e" "$reset"
  return "$e"
}

__jobs_ps1() {
  local c e="$?"
  c="$(jobs | wc -l)"
  [ "$c" -gt 0 ] && printf "%s%%%s%s " "$yellow" "$c" "$reset"
  return "$e"
}

export PS1='$(__jobs_ps1)\[$gray\][\[$green\]\u\[$yellow\]@\[$hostc\]\H\[$gray\]]\[$reset\] \w $(__status_ps1)\$ '

alias v=nvim
alias t="tmux attach || tmux"

if command -v asdf &>/dev/null; then
  export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
  . <(asdf completion bash)
fi
