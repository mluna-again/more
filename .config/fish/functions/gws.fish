function gws -d "Switch to a Git Worktree with FZF"
  set -l tree (
    find ~/Worktrees -mindepth 2 -maxdepth 2 -type d ! -path ~/Worktrees | \
    sed "s|$HOME/Worktrees/||" | \
    fzf --prompt=" " --ghost="Select worktree"
  )
  if test -z "$tree"
    return 1
  end

  cd "$HOME/Worktrees/$tree"; or return 1
end
