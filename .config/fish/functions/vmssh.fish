function vmssh
  set -l user $argv[1]
  if test -z $user
    set user user
  end
  set -l vm $argv[2]

  if echo $argv | grep -iq help
    printf "Usage:\n\$ vmssh [<user>] [<VM name>] \n"
    return 1
  end

  if not test -d ~/VMs
    echo "No VMs directory." 1>&2
    return 1
  end

  set -l config_files (find ~/VMs -type f -iname "*.conf" -exec basename {} \;)
  if test -z "$config_files"
    echo "No config files detected." 1>&2
    return 1
  end
  set -l selected (echo "$config_files" | fzf -1 -q "$vm")
  if test -z "$selected"
    return 1
  end

  quickemu --vm ~/VMs/$selected --display none --ssh-port 22220 ; or return 1
  echo "Connecting..."

  TERM=xterm-256color ssh -p22220 $user@localhost
end
