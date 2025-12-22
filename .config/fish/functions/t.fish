function t
    if pgrep -u "$USER" tmux &>/dev/null
      if tmux has-session -t void &>/dev/null
        tmux attach -t void
        return
      end

      tmux new-session -A -n null -s void
      return
    end

    tmux new-session -A -n null -s void
end

