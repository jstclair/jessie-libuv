FROM debian:jessie
MAINTAINER john.stclair@miles.no

# jessie supports >= GLIB 2.14, wheezy doesn't (compatible version install via mono?)
# update and install build-tools + libunwind8 (for DNX)
RUN apt-get -qq update \
    && apt-get -qqy install \
    autoconf \
    automake \
    build-essential \
    curl \
    libtool \
    libunwind8 \
    unzip

# Install libuv for Kestrel from source code (binary is not in wheezy and one in jessie is still too old)
RUN LIBUV_VERSION=1.4.2 \
    && curl -sSL https://github.com/libuv/libuv/archive/v${LIBUV_VERSION}.tar.gz | tar zxfv - -C /usr/local/src \
    && cd /usr/local/src/libuv-$LIBUV_VERSION \
    && sh autogen.sh && ./configure && make && make install \
    && rm -rf /usr/local/src/libuv-$LIBUV_VERSION \
    && ldconfig

RUN apt-get -y purge \
    autoconf \
    automake \
    build-essential \
    unzip \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/
