#! /usr/bin/env bash

die() {
  echo -e "$*" 1>&2
  echo "[Press any key to exit]"
  read -n 1
  exit 1
}

root_data="$(kitten @ ls --match-tab state:active | jq '.[0].tabs[0].windows[] | {cmdline: .foreground_processes[0].cmdline, id: .id}')"
closed=
while read -r id cmdline; do
  kitten @ close-window --match id:"$id" || die "Something went wrong"
  closed=1
done < <(echo "$root_data" | jq -r '"\(.id) " + (.cmdline | join(" "))' | grep -E -e 'ssh.*_bum$' -e '^[0-9]+\sbum$')

if [ -n "$closed" ]; then
  exit
fi

ssh_cmd="$(echo "$root_data" | jq -s -r '. | .[].cmdline | select((. | length) > 1 and ((.[0] | endswith("ssh")) or (.[1] | endswith("vm_ssh.sh")))) | join(" ")' | grep -v '_bum')"
ssh_cmd_lines="$(echo "$ssh_cmd" | wc -l)"
if (( ssh_cmd_lines == 1 )) && [ -n "$ssh_cmd" ]; then
  host="$(awk '{if (NF == 2) {print $2} else {print $3}}' <<< "$ssh_cmd")"
  host="${host}_bum"
  if ! grep -riEq "Host\s+$host" ~/.ssh/config ~/.ssh/config.d; then
    die "No matching entry in ~/.ssh/config\nExpected a hostname named $host, none found.\nAdd an entry with the appropiate 'bum -toggle' RemoteCommand."
  fi
  kitten @ launch --type window --location first --bias 20 ssh "$host"
else
  die "Could not infer host to connect to. Expected a *single* window with a cmd with the following format: \`ssh <host>\` or \`bash ~/.local/scripts/bin/vm_ssh.sh <host>\`.\nFound:\n${ssh_cmd:-Nothing}"
fi
