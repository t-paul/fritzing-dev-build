#!/bin/bash -e

TAG="fritzing/build:experimental"
DIR="$(pwd)/fritzing-app"
VER="1.0.2c"

BRANCH=develop
GIT_USER="Fritzing"
GIT_MAIL="<none>"

if [ -d fritzing-app ]
then
	(
		rm -rf fritzing-app/fritzing-*.linux.*
		cd fritzing-app && git clean -xdf && git reset --hard
		git checkout "$BRANCH"
		git branch -D build || true
		git pull
	)
else
	git clone https://github.com/fritzing/fritzing-app
fi

NGSPICE="$(grep NGSPICEPATH.*[0-9]$ fritzing-app/pri/spicedetect.pri | sed -e 's,.*/,,')"
docker build --tag "$TAG" --build-arg=NGSPICE="$NGSPICE" docker

(
	cd fritzing-app
	git config user.name "$GIT_USER"
	git config user.email "$GIT_MAIL"
	git checkout -b build "$BRANCH"
	patch -p1 < ../patches/01-project.patch
	patch -p1 < ../patches/02-build-script.patch
	git commit -a -m "Build Patches"
)

COOKIE=$(xauth list | head -n 1 | awk '{ print ":0", $2, $3}')

docker run \
	-it \
	--privileged \
	--ipc=host \
	--env LANG=C.UTF-8 \
	--env COOKIE="$COOKIE" \
	--env DISPLAY="$DISPLAY" \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v "$DIR:/fritzing" \
	-w /fritzing \
	"$TAG" \
	bash -c 'xauth add $COOKIE && ./tools/linux_release_script/release.sh '"$VER"
