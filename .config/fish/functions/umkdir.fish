function umkdir
  if test -z "$argv"
    echo """Usage:
    umkdir <dir> # podman unshare mkdir <dir> && podman unshare chown -R 1000:1000 <dir>"""
    return 1
  end

  podman unshare mkdir "$argv[1]"; or return 1
  podman unshare chown -R 1000:1000 "$argv[1]"; or return 1
end
