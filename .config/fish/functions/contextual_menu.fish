function contextual_menu
  if test -f selune.sh
    selune
    return
  end

  printf "No selune.sh script in current directory.\n\n"
  return 1
end
