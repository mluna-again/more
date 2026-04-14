#! /usr/bin/env bash

center_py="import sys, shutil; w,_=shutil.get_terminal_size((80,10)); print('\n'.join([line.strip().center(w) for line in sys.stdin]))"

case "$1" in
  "Even Horizontal")
    cat - <<EOF | python -c "$center_py"
┏━━━━━━┳━━━━━━┓
┃      ┃      ┃
┃      ┃      ┃
┃      ┃      ┃
┃      ┃      ┃
┃      ┃      ┃
┗━━━━━━┻━━━━━━┛
EOF
    ;;
  "Even Vertical")
    cat - <<EOF | python -c "$center_py"
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
    cat - <<EOF | python -c "$center_py"
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
    cat - <<EOF | python -c "$center_py"
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
    cat - <<EOF | python -c "$center_py"
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
    cat - <<EOF | python -c "$center_py"
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
    cat - <<EOF | python -c "$center_py"
┏━━━━━━┳━━━━━━┓
┃      ┃      ┃
┃      ┃      ┃
┣━━━━━━╋━━━━━━┫
┃      ┃      ┃
┃      ┃      ┃
┗━━━━━━┻━━━━━━┛
EOF
    ;;

  "Centered")
    cat - <<EOF | python -c "$center_py"
┏━━━┳━━━━━┳━━━┓
┃   ┃     ┃   ┃
┃   ┃     ┃   ┃
┣━━━┫     ┣━━━┫
┃   ┃     ┃   ┃
┃   ┃     ┃   ┃
┗━━━┻━━━━━┻━━━┛
EOF
    ;;
esac
