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
    "$HOME/Scripts" \
    "$HOME/.local/zig" \
    "$HOME/.local/odin" \
    "$HOME/.local/bin/nvim/bin" \
    "$HOME/.bun/bin"

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
set -gx VISUAL nvim
set -gx EDITOR "$VISUAL"
set -gx FZF_DEFAULT_COMMAND 'ag -g ""'
set -gx ELIXIR_ERL_OPTIONS "-kernel shell_history enabled"
set -gx ERL_AFLAGS "-kernel shell_history enabled -kernel shell_history_file_bytes 1024000"
set -gx GOPATH "$HOME/.local/go"
set -gx SHELLCHECK_OPTS "-e SC2001 -e SC1090"
set -gx MANPAGER "nvim '+Man!'"
set -gx AUTOSSH_PORT 0
set -gx POSTING_THEME_DIRECTORY "$HOME/.config/posting/themes"

abbr --add pg pgcli -h 127.0.0.1 -u postgres
abbr --add dots yadm
abbr --add dotss yadm status
abbr --add dotsa yadm add -u
abbr --add dotsA yadm add
abbr --add dotsl "yadm log --color --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
abbr --add dotsC yadm checkout
abbr --add dotsR yadm reset --hard
abbr --add dotsp yadm push
abbr --add dotsd yadm diff
abbr --add dotsdd yadm diff --cached
abbr --add gd git diff
abbr --add gdd git diff --cached
abbr --add gl "git log --color --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
abbr --add gCC git clean -fd
abbr --add gC git checkout
abbr --add gb "git checkout (git branch --sort=-committerdate -a | sed 's/\*/ /' | fzf | xargs)"
abbr --add gP git pull
abbr --add gp git push
abbr --add gs git status
abbr --add gss git stash list -p
abbr --add ga git add .
abbr --add gA git add
abbr --add gr git reset --soft
abbr --add gofmt go fmt ./...
abbr --add dateiso date +"%Y-%m-%dT%H:%M:%S%z"
abbr --add emacs "emacsclient -a '' -c --tty"
abbr --add doom '~/.config/emacs/bin/doom'
abbr --add setup-idf source "$HOME/esp/esp-idf/export.fish"
abbr --add esp idf.py
abbr --add rsync rsync -avh --info=progress2
abbr --add p fish -P
abbr --add un podman unshare
abbr --add work SHELL=/usr/bin/fish toolbox enter work
abbr --add mv mv -i
abbr --add rubydocs gem rdoc --all --ri --no-rdoc
abbr --add llsblk lsblk -o "NAME,MAJ:MIN,RM,SIZE,RO,FSTYPE,MOUNTPOINT,UUID"
abbr --add oil nvim -c 'Oil'
abbr --add --set-cursor oilssh nvim oil-ssh://%/
abbr --add nv NVIM_APPNAME=bare_nvim nvim
abbr --add pager $MANPAGER
abbr --add ss ss -nlput
abbr --add dtrees cd '(trees.sh dir)'
abbr --add ympv mpv --script-opts=ytdl_hook-ytdl_path=yt-dlp
abbr --add gv nvim --listen /tmp/godot.pipe
abbr --add r bin/rails

set fish_cursor_default block
set fish_cursor_insert block
set fish_cursor_replace_one underscore
set fish_cursor_replace underscore
set fish_cursor_external line
set fish_cursor_visual block

command -v bat &>/dev/null; and function cat
    bat $argv
end

# ASDF configuration code
if test -z $ASDF_DATA_DIR
    set _asdf_shims "$HOME/.asdf/shims"
else
    set _asdf_shims "$ASDF_DATA_DIR/shims"
end

# Do not use fish_add_path (added in Fish 3.2) because it
# potentially changes the order of items in PATH
if not contains $_asdf_shims $PATH
    set -gx --prepend PATH $_asdf_shims
end
set --erase _asdf_shims

if status is-interactive
  # Commands to run in interactive sessions can go here
  command -v atuin &>/dev/null; and atuin init fish --disable-up-arrow | source
  command -vq direnv; and direnv hook fish | source
  command -vq starship; and starship init fish | source

  set -g _host (hostname)
  function fish_title
    echo "$_host"
  end
end

if test -n "$fish_private_mode"
  set -x STARSHIP_FISH_PRIVATE_MODE "$fish_private_mode"
end
