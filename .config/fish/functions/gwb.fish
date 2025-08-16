function gwb -d "Go to original Git repo when inside a Worktree"
  if not test -f .git
    echo not inside a worktree
    return 1
  end

  set -l dir (awk -F': ' '{print $2}' .git | sed 's|/\.git.*||')
  echo "Switching to $dir"
  cd "$dir"
end
