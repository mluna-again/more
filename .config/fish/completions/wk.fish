complete -c wk --no-files
complete -c wk --condition "not __fish_seen_subcommand_from cd ls rm" --arguments 'cd' --description "Switch into a worktree"
complete -c wk --condition "not __fish_seen_subcommand_from cd ls rm" --arguments 'ls' --description "List worktrees"
complete -c wk --condition "not __fish_seen_subcommand_from cd ls rm" --arguments 'rm' --description "Remove worktrees"
complete -c wk --condition "__fish_seen_subcommand_from cd" --arguments "(git branch -a --format='%(refname:short)' 2>/dev/null | grep -vx \"\$(git branch --show-current 2>/dev/null)\")"
complete -c wk --condition "__fish_seen_subcommand_from rm" --arguments "(find .worktrees -maxdepth 1 -mindepth 1 -type d 2>/dev/null | sed 's|.*.worktrees/||')"
complete -c wk --short h --long h --description "Display help"
complete -c wk --short f --long force --condition "__fish_seen_subcommand_from rm" --description "Don't ask for confirmation"
