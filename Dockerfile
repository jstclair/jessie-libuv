FROM debian:jessie
MAINTAINER john.stclair@miles.no

ENV LIBUV_VERSION 1.4.2

ENV BUILD_PACKAGES autoconf automake build-essential libtool unzip
ENV RUNTIME_PACKAGES libunwind8 curl libc6-dev
# jessie supports >= GLIB 2.14, wheezy doesn't (compatible version install via mono?)
# update and install build-tools + libunwind8 (for DNX)
RUN apt-get -qq update \
    && apt-get -qqy install $BUILD_PACKAGES \
    && apt-get -qqy install $RUNTIME_PACKAGES \
    && curl -sSL https://github.com/libuv/libuv/archive/v${LIBUV_VERSION}.tar.gz | tar zxfv - -C /usr/local/src \
    && cd /usr/local/src/libuv-$LIBUV_VERSION \
    && sh autogen.sh && ./configure && make && make install \
    && rm -rf /usr/local/src/libuv-$LIBUV_VERSION \
    && ldconfig \ 
    && apt-get remove --purge -y $BUILD_PACKAGES $(apt-mark showauto) && rm -rf /var/lib/apt/lists/*

RUN apt-get -qq update \
    && apt-get -qqy install $RUNTIME_PACKAGES \
    && apt-get remove --purge -y $BUILD_PACKAGES && rm -rf /var/lib/apt/lists/*
    
 
