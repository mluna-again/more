#! /usr/bin/env bash

options="'Start applications' s 'run-shell ~/.local/scripts/bin/tmux_start_apps.sh'"
options="${options} 'Run command' r 'run-shell ~/.local/scripts/bin/tmux_run_cmd_in_everypane.sh'"

eval tmux display-menu -T " Runner " -x C -y "10%" "$options"
