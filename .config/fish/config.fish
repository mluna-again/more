set -U fish_greeting
set -g fish_key_bindings fish_vi_key_bindings
set -g fish_color_valid_path

set -e fish_user_paths
set -U fish_user_paths /usr/local/bin \
    /opt/homebrew/bin \
    /opt/homebrew/sbin \
    "$HOME/.local/go/bin" \
    "$HOME/.local/bin" \
    "$HOME/.dotnet/tools" \
    "$HOME/.cargo/bin" \
    "/usr/local/go/bin" \
    "$HOME/.local/scripts/bin" \
    "$HOME/.local/share/bob/nvim-bin" \
    "$HOME/.local/gem/bin" \
    "$HOME/Scripts"

bind -M insert \ce end-of-line
bind -M insert \ca beginning-of-line
bind -M insert \ck accept-autosuggestion
bind -M insert \cp history-search-backward
bind -M insert \cn history-search-forward
bind -M insert \cb edit_command_buffer
bind -M insert \cw backward-kill-path-component
bind -M insert \cr history-pager
bind -M insert \co edit_command_buffer
bind --mode insert --sets-mode default jj backward-char repaint

set -gx CURL_HOME "$HOME/.config/curl"
set -gx HOMEBREW_NO_AUTO_UPDATE 1
set -gx COLORTERM truecolor
set -gx VISUAL "nvim -u NONE"
set -gx EDITOR "$VISUAL"
set -gx FZF_DEFAULT_COMMAND 'ag -g ""'
set -gx FZF_DEFAULT_OPTS '--ellipsis=... --layout=reverse --prompt=" " --height="100%" --header-first --no-separator --preview-window=border-none --border=none --info=inline-right --pointer="▌" --header="Search" --color="bg:#12120f,preview-bg:#1D1C19,gutter:#12120f,pointer:#c4746e,hl:#c4746e,hl+:#c5c9c5,bg+:#7a8382,fg:#c5c9c5,fg+:#181816,header:#c4b28a,prompt:#c4b28a,query:#c5c9c5" --cycle --bind="down:preview-down,up:preview-up" --no-scrollbar'
set -gx ELIXIR_ERL_OPTIONS "-kernel shell_history enabled"
set -gx ERL_AFLAGS "-kernel shell_history enabled -kernel shell_history_file_bytes 1024000"
set -gx GOPATH "$HOME/.local/go"
set -gx SHELLCHECK_OPTS "-e SC2001"
set -gx GEM_HOME "$HOME/.local/gem"
set -gx MANPAGER "nvim +Man!"

abbr --add pg pgcli -h 127.0.0.1 -u postgres
abbr --add dots yadm
abbr --add dotss yadm status
abbr --add dotsa yadm add -u
abbr --add dotsA yadm add
abbr --add dotsl yadm log
abbr --add dotsC yadm checkout
abbr --add dotsR yadm reset --hard
abbr --add dotsp yadm push
abbr --add dotsd yadm diff
abbr --add dotsdd yadm diff --cached
abbr --add gd git diff
abbr --add gdd git diff --cached
abbr --add gl git log
abbr --add gCC git clean -fd
abbr --add gC git checkout
abbr --add gb "git checkout (git branch --sort=-committerdate -a | sed 's/\*/ /' | fzf | xargs)"
abbr --add gP git pull
abbr --add gp git push
abbr --add gs git status
abbr --add ga git add .
abbr --add gA git add
abbr --add gr git reset --soft
abbr --add gofmt go fmt ./...
abbr --add dateiso date +"%Y-%m-%dT%H:%M:%S%z"
abbr --add emacsc "emacsclient -a '' -c --tty"
abbr --add setup-idf source "$HOME/.local/esp/esp-idf/export.fish"
abbr --add esp idf.py
abbr --add rsync rsync -avh --info=progress2
abbr --add p fish -P

if test "$TERM" = xterm-kitty
  abbr --add ssh kitten ssh
end

set fish_cursor_default block
set fish_cursor_insert block
set fish_cursor_replace_one underscore
set fish_cursor_replace underscore
set fish_cursor_external line
set fish_cursor_visual block

command -v z &>/dev/null; and function cd
    z $argv
end

command -v eza &>/dev/null; and function ls
    eza --icons -1 $argv
end

command -v eza &>/dev/null; and function ll
    eza --icons -1 -lh $argv
end

command -v bat &>/dev/null; and function cat
    bat --theme kanagawa-dragon $argv
end

if uname | grep -i darwin &>/dev/null
    set -l p (brew --prefix asdf)/libexec/asdf.fish
    test -e "$p"; and source "$p"
else
    set -l p ~/.asdf/asdf.fish
    test -e "$p"; and source "$p"
end

if status is-interactive
    # Commands to run in interactive sessions can go here
    command -v atuin &>/dev/null; and atuin init fish --disable-up-arrow | source
    command -vq fortune; and fortune | catsays -
    command -vq direnv; and direnv hook fish | source
    command -vq zoxide; and zoxide init fish | source
    command -vq starship; and starship init fish | source
end

if test -n "$fish_private_mode"
  set -x STARSHIP_FISH_PRIVATE_MODE "$fish_private_mode"
end
