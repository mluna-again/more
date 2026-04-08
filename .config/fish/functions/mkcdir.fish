function mkcdir
  set -l dir "$argv[1]"
  if test -z "$dir"
    return 1
  end

  if test -d "$dir"
    cd "$dir"; or return 1
    return 0
  end

  mkdir "$dir"; or return 1

  cd "$dir"
end
