#!/bin/bash -e

TAG="fritzing/build:experimental"

RUNDIR=$(echo $(pwd)/fritzing-app/fritzing-*.linux.*/)

docker run \
	-it \
	--privileged \
	--network=host \
	--env LANG=C.UTF-8 \
	--env DISPLAY=:0 \
	-v "$HOME/.Xauthority:/root/.Xauthority:rw" \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v "$HOME:/home/${USER}" \
	-v "$RUNDIR:/fritzing" \
	-w "/home/${USER}" \
	"$TAG" \
	/fritzing/Fritzing

