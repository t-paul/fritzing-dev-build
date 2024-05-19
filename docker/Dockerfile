FROM debian:experimental

RUN apt-get update && apt-get upgrade -y && apt-get install -t experimental -y --no-install-recommends \
	libjpeg-dev \
	libncurses-dev \
	libpng-dev \
	libssl-dev \
	libudev-dev \
	libz-dev \
	libgit2-dev \
	ngspice-dev \
	libsvgpp-dev \
	libngspice0-dev \
	libpolyclipping-dev \
	libboost-all-dev \
	python3-dev \
	ca-certificates \
	qmake6 \
	qt6-base-dev \
	qt6-svg-dev \
	qt6-l10n-tools \
	qt6-5compat-dev \
	qt6-serialport-dev \
	qt6-base-dev-tools \
	qt6-tools-dev-tools \
	libqt6sql6-sqlite \
	pkg-config \
	openssl \
	xauth \
	cmake \
	make \
	xvfb \
	git \
	g++

RUN \
	cd / && \
	git clone https://github.com/stachenov/quazip && \
	cd quazip && \
	cmake -B build && \
	cmake --build build && \
	cd build && \
	make install

RUN ln -s /usr /ngspice-40
RUN ln -s /usr/local /quazip-$(qmake6 -query QT_VERSION)-1.4
RUN git config --global --add safe.directory /fritzing
