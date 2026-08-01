function wk --description "call trees.sh"
  set -l tmp (mktemp)
  trees.sh $argv | tee "$tmp"
  set -l statcode $pipestatus[1]
  set -l dir (cat "$tmp" | tail -n 1)

  if test -d "$dir"
    builtin cd -- "$dir"
  end

  command rm -f "$tmp"

  return "$statcode"
end
