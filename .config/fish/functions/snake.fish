function snake
  echo $argv | sed -e 's|^\s*||' -e 's|\s*$||' -e 's| |_|g' | tr '[[:upper:]]' '[[:lower:]]'
end
