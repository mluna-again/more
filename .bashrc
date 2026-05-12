# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
PATH="$HOME/go/bin:$PATH"
export PATH

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
gray="$(tput setaf 5)"
green="$(tput setaf 2)"
yellow="$(tput setaf 3)"
reset="$(tput sgr0)"
export PS1='\[$gray\][\[$green\]\u\[$yellow\]@\[$hostc\]\H\[$gray\]]\[$reset\] \w $ '

alias v=nvim
alias t="tmux attach || tmux"

if command -v asdf &>/dev/null; then
  export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
  . <(asdf completion bash)
fi
