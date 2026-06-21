#! /usr/bin/env bash

die() {
  echo -e "$*" 1>&2
  exit 1
}

kitty_window_cmdlines="$(kitten @ ls --match-tab state:active | jq '.[0].tabs[0].windows[].foreground_processes[0].cmdline')"
ssh_cmd="$(echo "$kitty_window_cmdlines" | jq -r '. | select((. | length) > 1 and ((.[0] | endswith("ssh")) or (.[1] | endswith("vm_ssh.sh")))) | join(" ")')"
ssh_cmd_lines="$(echo "$ssh_cmd" | wc -l)"
if (( ssh_cmd_lines == 1 )) && [ -n "$ssh_cmd" ]; then
  host="$(awk '{if (NF == 2) {print $2} else {print $3}}' <<< "$ssh_cmd")"
  cmd="$(awk '{print $1}' <<< "$ssh_cmd")"
  if [ "$cmd" = bash ]; then
    vm_ssh.sh "$host" --cmd "bum -toggle"
  else
    ssh -t "$host" -o RemoteCommand="bum -toggle"
  fi
else
  die "Could not infer host to connect to. Expected a *single* window with a cmd with the following format: \`ssh <host>\` or \`bash ~/.local/scripts/bin/vm_ssh.sh <host>\`.\nFound:\n${ssh_cmd:-Nothing}"
fi
