function mksess
  if test -z $argv[1]
    printf "Usage:\nmksess <session_name>\n" >&2
    return 1
  end

  set -l name "$argv[1]"
  if echo "$name" | grep -vqE '.ya?ml$'
    set name "$name.yaml"
  end

  if test -f "$name"
    echo "File already exists"
    return 1
  end

  echo "session_name: $argv[1]" | tee "$name"
  echo "windows:" | tee -a "$name"
  echo "  - window_name: starter" | tee -a "$name"
  echo "    focus: true" | tee -a "$name"
  echo "    layout: tiled" | tee -a "$name"
  echo "    start_directory: ~/" | tee -a "$name"
  echo "    panes:" | tee -a "$name"
  echo "      - shell_command:" | tee -a "$name"
  echo "        - pwd" | tee -a "$name"
  echo "        focus: true" | tee -a "$name"
  echo "        start_directory: ~/" | tee -a "$name"
  echo
  echo "Saved in $name"
end
