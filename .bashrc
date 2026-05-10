# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
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

gray="$(tput setaf 5)"
green="$(tput setaf 2)"
red="$(tput setaf 1)"
yellow="$(tput setaf 3)"
reset="$(tput sgr0)"
export PS1='\[$gray\][\[$green\]\u\[$yellow\]@\[$red\]\H\[$gray\]]\[$reset\] \w $ '
