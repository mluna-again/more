function vmssh
  set -l user $argv[1]
  if test -z $user
    set user user
  end

  if echo $argv | grep -iq help
    printf "Usage:\n\$ vmssh [<user>]\n"
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
  set -l selected (echo "$config_files" | fzf)
  if test -z "$selected"
    return 1
  end

  ~/VMs/$selected ; or return 1
  echo "Connecting..."
  echo ssh -p22220 $user@localhost
  ssh -p22220 $user@localhost
end
