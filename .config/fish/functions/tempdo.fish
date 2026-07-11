function tempdo --description "Creates a tmp directory in /tmp, drops you in a new shell, and removes the directory after you exit"
  set -l dir (mktemp --directory /tmp/tmp.XXXXXXXX) ; or return
  echo "New fish shell starting, type C-d or exit when done"
  __TEMPDO=1 fish -C "cd $dir"
  rm -rf "$dir" ; or return
  echo "$dir" removed
end
