function romount --description "Mounts a filesystem as read-only"
  set -l source "$argv[1]"
  set -l target "$argv[2]"
  
  if test -z "$source"; or not test -e "$source"
    echo "source doesn't exist" >&2
    return 1
  end

  if test -z "$target"; or not test -e "$target"
    echo "target doesn't exist" >&2
    return 1
  end
  
  sudo mount -o bind "$source" "$target" || return
  sudo mount -o bind,remount,ro "$source" "$target"
end
