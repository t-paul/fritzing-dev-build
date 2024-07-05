#!/bin/bash -e

TAG="fritzing/build:experimental"

RUNDIR=$(echo $(pwd)/fritzing-app/fritzing-*.linux.*/)
COOKIE=$(xauth list | head -n 1 | awk '{ print ":0", $2, $3}')

docker run \
	-it \
	--privileged \
	--ipc=host \
	--env USER="$USER" \
	--env LANG=C.UTF-8 \
	--env DISPLAY="$DISPLAY" \
	--env COOKIE="$COOKIE" \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v "$HOME:/home/${USER}" \
	-v "$RUNDIR:/fritzing" \
	-w "/home/${USER}" \
	"$TAG" \
	bash -c 'export HOME="/home/${USER}" && xauth add $COOKIE && /fritzing/Fritzing'

