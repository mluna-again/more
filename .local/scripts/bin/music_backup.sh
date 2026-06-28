#! /usr/bin/env bash

BACKUP_MUSIC_DIR="${BACKUP_MUSIC_DIR:-$HOME/Music/}"
BACKUP_MUSIC_DEST="${BACKUP_MUSIC_DEST:-/pond/root/Music}"
BACKUP_MUSIC_OPUS="${BACKUP_MUSIC_OPUS:-$HOME/Opus/}"
if [ -z "${BACKUP_MUSIC_REMOTE+x}" ]; then
  BACKUP_MUSIC_REMOTE="aztlan:/tank/root"
fi

# shellcheck disable=SC2120
usage() {
  cat - <<EOF
Backs up my music in \$BACKUP_MUSIC_DIR to \$BACKUP_MUSIC_DEST.
It also makes an OPUS copy in \$BACKUP_MUSIC_OPUS and backs it to to \$BACKUP_MUSIC_REMOTE (if any).
Uses \`flac_to_opus.sh\` --today by default.

Usage:
$ music_backup.sh

Flags:
  --all    add --all flag when running \`flac_to_opus.sh\`.
  --force  add --force flag when running \`flac_to_opus.sh\`.

Env variables:
  Name                  Description                                                       Default
  \$BACKUP_MUSIC_DIR     Where the original copy of the music goes.                        $HOME/Music/
  \$BACKUP_MUSIC_DEST    Where the backup of the original copy of the music goes.          /pond/root/Music
  \$BACKUP_MUSIC_OPUS    Where the OPUS copy of the music goes.                            $HOME/Opus/
  \$BACKUP_MUSIC_REMOTE  Where the remote (ssh-able address) OPUS copy of the music goes.  aztlan:/tank/root

WARNING: Be careful with the trailing slashes!!! rsync stuff.
WARNING: Remember, trailing slash = *ALL INSIDE DIRECTORY*, not the directory itself.

NOTES:
  1. To disable remote backup set \$BACKUP_MUSIC_REMOTE to an empty string (eg. BACKUP_MUSIC_REMOTE= music_backup.sh). This also disables Opus re-encoding.
EOF
  if [ "$#" -gt 0 ]; then
    echo
    tput setab 1
    tput setaf 0
    printf " ERROR "
    tput sgr0
    echo " $*"
  fi
  exit 1
}

flac_to_opus_flags=()
all_flag_added=0
while true; do
  [ -z "$1" ] && break

  case "$1" in
    --help|-h|help)
      usage
      ;;

    --all)
      flac_to_opus_flags+=( --all )
      all_flag_added=1
      ;;

    --force)
      flac_to_opus_flags+=( --force )
      ;;
  esac

  shift
done

if [ "$all_flag_added" -eq 0 ]; then
  flac_to_opus_flags+=( --today )
fi

opus_cmd=( flac_to_opus.sh "${flac_to_opus_flags[@]}" "$BACKUP_MUSIC_DIR" "$BACKUP_MUSIC_OPUS" )
backup_cmd=( rsync -avhbu --info=progress2 "$BACKUP_MUSIC_DIR" "$BACKUP_MUSIC_DEST" )
opus_backup_cmd=( rsync -avhbu --info=progress2 "$BACKUP_MUSIC_OPUS" "$BACKUP_MUSIC_REMOTE" )

echo "================ About to run ================"
[ -n "$BACKUP_MUSIC_REMOTE" ] && echo "${opus_cmd[@]}"
echo "${backup_cmd[@]}"
[ -n "$BACKUP_MUSIC_REMOTE" ] && echo "${opus_backup_cmd[@]}"
echo "================ About to run ================"
printf "Continue? [N/y] "
read -r response
if [[ ! "${response,,}" =~ ^y(es)?$ ]]; then
  exit 1
fi

if [ -n "$BACKUP_MUSIC_REMOTE" ]; then
  "${opus_cmd[@]}" || exit
fi
"${backup_cmd[@]}" || exit
if [ -n "$BACKUP_MUSIC_REMOTE" ]; then
  "${opus_backup_cmd[@]}" || exit
fi

echo
echo "Done :D"
