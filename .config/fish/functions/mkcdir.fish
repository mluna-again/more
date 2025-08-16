function mkcdir
  set -l dir "$argv[1]"
  if test -z "$dir"
    return 1
  end

  mkdir -p "$dir"; or return 1

  cd "$dir"
end
