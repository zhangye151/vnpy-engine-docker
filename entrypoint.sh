#!/bin/sh
set -e

mkdir -p "$HOME/.vnc"
echo "$VNC_PASSWORD" | x11vnc -storepasswd - "$HOME/.vnc/passwd"
chmod 600 "$HOME/.vnc/passwd"

Xvfb $DISPLAY -screen 0 ${VNC_RESOLUTION}x24 &
sleep 2

fluxbox &

x11vnc \
  -display $DISPLAY \
  -rfbauth "$HOME/.vnc/passwd" \
  -forever \
  -shared \
  -bg

exec vnpy
