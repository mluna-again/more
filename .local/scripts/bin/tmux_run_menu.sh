#! /usr/bin/env bash

options="'Gemma' g 'run-shell ~/.local/scripts/bin/tmux_gemma.sh'"
options="${options} 'Start applications' s 'run-shell ~/.local/scripts/bin/tmux_start_apps.sh'"
options="${options} 'Stop applications' S 'run-shell ~/.local/scripts/bin/tmux_stop_apps.sh'"
options="${options} 'Run command' r 'run-shell ~/.local/scripts/bin/tmux_run_cmd_in_everypane.sh'"
options="${options} 'Send Keys' k 'run-shell ~/.local/scripts/bin/tmux_sendkeys_everypane.sh'"
options="${options} 'Clear panes' C 'run-shell ~/.local/scripts/bin/tmux_clear_everypane.sh'"
options="${options} 'Todo' m 'run-shell ~/.local/scripts/bin/tmux_goto_todo.sh'"
options="${options} 'Matrix' M 'run-shell ~/.local/scripts/bin/tmux_matrix.sh'"
options="${options} 'Close empty panels' X 'run-shell ~/.local/scripts/bin/tmux_close_empty_panels.sh'"
options="${options} 'Toggle panel borders' P 'run-shell ~/.local/scripts/bin/tmux_toggle_panel_borders.sh'"
options="${options} 'Private mode' p 'run-shell ~/.local/scripts/bin/tmux_priv.sh'"
options="${options} 'Autism' $ 'run-shell ~/.local/scripts/bin/tmux_hacktheworld.sh'"

eval tmux display-menu -T " Runner " -x C -y "10%" "$options"
