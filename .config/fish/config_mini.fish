function fish_prompt -d "Write out the prompt"
  set -l s "$status"
  set -l c (jobs | wc -l)
  set -l cm
  if test "$c" -gt 0
    set cm (set_color yellow)"%$c "(set_color normal)
  end

  set -l sm
  if test "$s" != 0
    set sm (set_color red)"$s "(set_color normal)
  end
  printf '%s[%s%s%s@%s%s%s%s] %s %s$ ' "$cm" (set_color green) "$USER" (set_color yellow) (set_color normal) (set_color red) "$hostname" (set_color normal) (prompt_pwd) "$sm"
end

set -g fish_key_bindings fish_vi_key_bindings
set -g fish_color_valid_path

set -g fish_user_paths /usr/local/bin \
    "$HOME/.local/go/bin" \
    "$HOME/.local/bin" \
    "$HOME/.dotnet/tools" \
    "$HOME/.cargo/bin" \
    "/usr/local/go/bin" \
    "$HOME/.local/scripts/bin" \
    "$HOME/.local/share/bob/nvim-bin"

bind -M insert \ce end-of-line
bind -M insert \ca beginning-of-line
bind -M insert \ck accept-autosuggestion
bind -M insert \cp history-search-backward
bind -M insert \cn history-search-forward
bind -M insert \cb edit_command_buffer
bind -M insert \cw backward-kill-path-component
bind -M insert \cc cancel-commandline
bind --mode insert --sets-mode default jj backward-char repaint
bind -M insert f1 true
bind -M insert f2 true
bind -M insert f3 true
bind -M insert f4 true
bind -M insert f5 true
bind -M insert f6 true
bind -M insert f7 true
bind -M insert f8 true
bind -M insert f9 true
bind -M insert f10 true

set -gx VISUAL nvim
set -gx EDITOR "$VISUAL"
set -gx GOPATH "$HOME/.local/go"
set -gx TMUXP_CONFIGDIR "$HOME/.local/tmuxp"
if command -vq fd
  set -gx FZF_DEFAULT_COMMAND 'fd'
else
  set -gx FZF_DEFAULT_COMMAND 'find . -mindepth 1 -type f -printf "%P\n"'
end
set -gx FZF_DEFAULT_OPTS '--ellipsis=...
  --border=none
  --padding=1
  --layout=reverse
  --prompt=""
  --height="100%"
  --preview-window=border-none
  --marker="=>"
  --info=inline-right
  --pointer=""
  --no-bold
  --no-header-lines-border
  --color="bg:,border:,label:red,gutter:,pointer:,hl:white,hl+:black,bg+:yellow,fg:white,fg+:black,header:white,prompt:white,query:white"
  --cycle
  --bind="down:preview-down,up:preview-up,ctrl-a:select-all"
  --no-scrollbar'

abbr --add cd.. cd ..
abbr --add cd- cd -
abbr --add v nvim
abbr --add t tmux new-session -A -n null -s void
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
abbr --add gc --set-cursor git commit -m \"%\"
abbr --add gR git reset --hard
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
abbr --add dotsc --set-cursor yadm commit -m \"%\"
abbr --add dotsP yadm pull
abbr --add mv mv -i
abbr --add op opencode
abbr --add doeach "fzf --multi | entr -rp"

function mkcdir
  set -l dir "$argv[1]"
  if test -z "$dir"
    return 1
  end

  if test -d "$dir"
    cd "$dir"; or return 1
    return 0
  end

  mkdir "$dir"; or return 1

  cd "$dir"
end

set fish_cursor_default block
set fish_cursor_insert block blink
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
  if command -vq atuin;
    atuin init fish --disable-up-arrow | source
    bind -M insert \cf zi \; repaint
  else
    bind -M insert \cr history-pager
  end

  command -vq direnv; and direnv hook fish | source
  command -vq zoxide; and zoxide init fish | source
  command -vq fzf; and fzf --fish | FZF_CTRL_R_COMMAND= FZF_ALT_C_COMMAND= FZF_CTRL_T_COMMAND= source
end
