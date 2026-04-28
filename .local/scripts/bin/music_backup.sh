#! /usr/bin/env bash

BACKUP_MUSIC_DIR="${BACKUP_MUSIC_DIR:-$HOME/Music/}"
BACKUP_MUSIC_DEST="${BACKUP_MUSIC_DEST:-/pond/root/Music}"
BACKUP_MUSIC_OPUS="${BACKUP_MUSIC_OPUS:-$HOME/Opus/}"
BACKUP_MUSIC_REMOTE="${BACKUP_MUSIC_REMOTE:-aztlan:/tank/root}"

# shellcheck disable=SC2120
usage() {
  cat - <<EOF
Backs up my music in ~/Music to /pond/root.
It also makes an OPUS copy in ~/Opus and backs it to to \$BACKUP_MUSIC_REMOTE (if any).
Uses \`flac_to_opus.sh\` --today by default.

Usage:
$ music_backup.sh

Flags:
  --all    omit --today flag when running \`flac_to_opus.sh\`.

Env variables:
  Name                  Description                                                       Default
  \$BACKUP_MUSIC_DIR     Where the original copy of the music goes.                        $HOME/Music/
  \$BACKUP_MUSIC_DEST    Where the backup of the original copy of the music goes.          /pond/root/Music
  \$BACKUP_MUSIC_OPUS    Where the OPUS copy of the music goes.                            $HOME/Opus/
  \$BACKUP_MUSIC_REMOTE  Where the remote (ssh-able address) OPUS copy of the music goes.  aztlan:/tank/root

WARNING: Be careful with the trailing slashes!!! rsync stuff.
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

opus_cmd=( flac_to_opus.sh --today )
while true; do
  [ -z "$1" ] && break

  case "$1" in
    --help|-h|help)
      usage
      ;;

    --all)
      opus_cmd=( flac_to_opus.sh )
      ;;
  esac

  shift
done

backup_cmd=( rsync -avhbu --info=progress2 "$BACKUP_MUSIC_DIR" "$BACKUP_MUSIC_DEST" )
opus_backup_cmd=( rsync -avhbu --info=progress2 "$BACKUP_MUSIC_OPUS" "$BACKUP_MUSIC_REMOTE" )

echo "================ About to run ================"
echo "${opus_cmd[@]}"
echo "${backup_cmd[@]}"
echo "${opus_backup_cmd[@]}"
echo "================ About to run ================"
printf "Continue? [N/y] "
read -r response
if [[ ! "${response,,}" =~ ^y(es)?$ ]]; then
  exit 1
fi

"${opus_cmd[@]}" || exit
"${backup_cmd[@]}" || exit
"${opus_backup_cmd[@]}" || exit

echo
echo "Done :D"
