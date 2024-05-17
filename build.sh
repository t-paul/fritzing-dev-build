#!/bin/bash -e

TAG="fritzing/build:experimental"
DIR="$(pwd)/fritzing-app"
VER="1.0.2c"

BRANCH=develop
GIT_USER="Fritzing"
GIT_MAIL="<none>"

docker build --tag "$TAG" docker

if [ -d fritzing-app ]
then
	( cd fritzing-app && git reset --hard && git checkout "$BRANCH" && ( git branch -D build || true ) && git pull )
else
	git clone https://github.com/fritzing/fritzing-app
fi

(
	cd fritzing-app
	git config user.name "$GIT_USER"
	git config user.email "$GIT_MAIL"
	git checkout -b build "$BRANCH"
	patch -p1 < ../patches/01-project.patch
	patch -p1 < ../patches/02-build-script.patch
	git commit -a -m "Build Patches"
)

docker run \
	-it \
	--network=host \
	--env LANG=C.UTF-8 \
	--env DISPLAY=:0 \
	--privileged \
	-v "$HOME/.Xauthority:/root/.Xauthority:rw" \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v "$DIR:/fritzing" \
	-w /fritzing \
	"$TAG" \
	bash -x ./tools/linux_release_script/release.sh "$VER"

