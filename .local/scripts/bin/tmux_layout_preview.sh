#! /usr/bin/env bash

padd=$(tput cols) || exit
padd=$(( padd / 2 ))

case "$1" in
  "Even Vertical")
    cat - <<EOF | ruby -ne "puts \$_.rjust($padd + \$_.size/2, ' ')"
┏━━━━━━┳━━━━━━┓
┃      ┃      ┃
┃      ┃      ┃
┃      ┃      ┃
┃      ┃      ┃
┃      ┃      ┃
┗━━━━━━┻━━━━━━┛
EOF
    ;;
  "Even Horizontal")
    cat - <<EOF | ruby -ne "puts \$_.rjust($padd + \$_.size/2, ' ')"
┏━━━━━━━━━━━━━┓
┃             ┃
┣━━━━━━━━━━━━━┫
┃             ┃
┣━━━━━━━━━━━━━┫
┃             ┃
┗━━━━━━━━━━━━━┛
EOF
    ;;
  "Main Horizontal")
    cat - <<EOF | ruby -ne "puts \$_.rjust($padd + \$_.size/2, ' ')"
┏━━━━━━━━━━━━━┓
┃             ┃
┃             ┃
┣━━━━━━┳━━━━━━┫
┃      ┃      ┃
┃      ┃      ┃
┗━━━━━━┻━━━━━━┛
EOF
    ;;
  "Main Horizontal Mirrored")
    cat - <<EOF | ruby -ne "puts \$_.rjust($padd + \$_.size/2, ' ')"
┏━━━━━━┳━━━━━━┓
┃      ┃      ┃
┃      ┃      ┃
┣━━━━━━┻━━━━━━┫
┃             ┃
┃             ┃
┗━━━━━━━━━━━━━┛
EOF
    ;;
  "Main Vertical")
    cat - <<EOF | ruby -ne "puts \$_.rjust($padd + \$_.size/2, ' ')"
┏━━━━━━┳━━━━━━┓
┃      ┃      ┃
┃      ┃      ┃
┃      ┣━━━━━━┫
┃      ┃      ┃
┃      ┃      ┃
┗━━━━━━┻━━━━━━┛
EOF
    ;;
  "Main Vertical Mirrored")
    cat - <<EOF | ruby -ne "puts \$_.rjust($padd + \$_.size/2, ' ')"
┏━━━━━━┳━━━━━━┓
┃      ┃      ┃
┃      ┃      ┃
┣━━━━━━┫      ┃
┃      ┃      ┃
┃      ┃      ┃
┗━━━━━━┻━━━━━━┛
EOF
    ;;
  "Tiled")
    cat - <<EOF | ruby -ne "puts \$_.rjust($padd + \$_.size/2, ' ')"
┏━━━━━━┳━━━━━━┓
┃      ┃      ┃
┃      ┃      ┃
┣━━━━━━╋━━━━━━┫
┃      ┃      ┃
┃      ┃      ┃
┗━━━━━━┻━━━━━━┛
EOF
    ;;
esac
