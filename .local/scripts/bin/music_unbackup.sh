#! /usr/bin/env bash

BACKUP_MUSIC_DIR="${BACKUP_MUSIC_DIR:-$HOME/Music/}"
BACKUP_MUSIC_DEST="${BACKUP_MUSIC_DEST:-/pond/root/Music}"
BACKUP_MUSIC_OPUS="${BACKUP_MUSIC_OPUS:-$HOME/Opus/}"
BACKUP_MUSIC_REMOTE="${BACKUP_MUSIC_REMOTE:-aztlan:/tank/root}"

# shellcheck disable=SC2120
usage() {
  cat - <<EOF
Sometimes life happens and I want to remove some music, you know? But I don't wanna go manually to every single copy and delete it.

This script will do the following:
  1. Remove original copy from ${BACKUP_MUSIC_DIR}.
  2. Remove backup copy from ${BACKUP_MUSIC_DEST}.
  3. Remove OPUS copy from ${BACKUP_MUSIC_OPUS}.
  4. Remove remote OPUS copy like this:
    4.1 Split \$BACKUP_MUSIC_REMOTE with \`awk -F: '{print $1; print $2}' <<< "\$BACKUP_MUSIC_REMOTE"\`.
    4.2 Run \`ssh \$1 " rm -rf \$2 "\`

Usage:
$ music_unbackup.sh [<fzf-able album name>]

Env variables are the same as music_backup.sh and they follow the same logic.

WARNING: Because of how step 4 works you need to have an SSH alias if using a custom port. Eg. aztlan:/tank/root instead of 192.168.1.254:2222:/tank/root
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

q=""
while true; do
  [ -z "$1" ] && break

  case "$1" in
    --help|-h|help)
      usage
      ;;

    *)
      q="$1"
      ;;
  esac

  shift
done

album="$(find "$BACKUP_MUSIC_DIR" -maxdepth 1 -mindepth 1 -type d -exec basename {} \; | fzf -1 -q "$q")" || exit
[ -z "$album" ] && exit 1

rm_original=( rm -rf "$(readlink -m "${BACKUP_MUSIC_DIR}/$album" )" )
rm_backup=( rm -rf "$(readlink -m "${BACKUP_MUSIC_DEST}/$album" )" )
rm_opus=( rm -rf "$(readlink -m "${BACKUP_MUSIC_OPUS}/$album" )" )
if [ "$BACKUP_MUSIC_REMOTE" != " " ]; then
  remote_host=$(awk -F: '{print $1}' <<< "$BACKUP_MUSIC_REMOTE") || exit
  remote_dir=$(awk -F: '{print $2}' <<< "$BACKUP_MUSIC_REMOTE") || exit
  remote_dir="$(readlink -m "$remote_dir")"
  rm_remote=( ssh "$remote_host" \" rm -rf \""${remote_dir}/$album"\" \" )
fi
echo "================ About to run ================"
echo "${rm_original[@]}"
echo "${rm_backup[@]}"
echo "${rm_opus[@]}"
[ "$BACKUP_MUSIC_REMOTE" != " " ] && echo "${rm_remote[@]}"
echo "================ About to run ================"

printf "Continue? [N/y] "
read -r response
if [[ ! "${response,,}" =~ ^y(es)?$ ]]; then
  exit 1
fi

"${rm_original[@]}" || exit
"${rm_backup[@]}" || exit
"${rm_opus[@]}" || exit
if [ "$BACKUP_MUSIC_REMOTE" != " " ]; then
  # shellcheck disable=SC2029
  ssh "$remote_host" " rm -rf \"${remote_dir}/$album\" "  || exit
fi

echo "Done :D"
