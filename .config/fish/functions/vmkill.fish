function vmkill
  if echo $argv | grep -iq help
    printf "Usage:\n\$ vmkill\n"
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

  quickemu --vm ~/VMs/$selected --kill
end
