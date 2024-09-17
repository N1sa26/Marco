#!/bin/bash
MODE=${1}
CODENAME="libxml2-v2.9.2"

ROOTDIR="/data/src/benchmarks/targets"
MODENAME="${MODE}_targets"
TARG_DIR="$ROOTDIR/$CODENAME/$MODENAME"
rm -rf "$TARG_DIR"
mkdir -p "$TARG_DIR"

make distclean

apt-get update && \
    apt-get install -y \
    make \
    wget \
    autoconf \
    automake \
    libtool \
    libglib2.0-dev

export CC="/data/src/CE${1}/bin/ko-clang"
export CXX="/data/src/CE${1}/bin/ko-clang++"
export KO_CC="clang-6.0"
export KO_CXX="clang++-6.0"
export KO_DONT_OPTIMIZE=1

# build lib
./autogen.sh --host=x86_64
CCLD="$CXX" ./configure --without-python --with-threads=no \
    --with-zlib=no --with-lzma=no --disable-shared
make -j $(nproc)

rm /driver.o
rm /driver.a
rm /usr/lib/libFuzzingEngine.a

# build driver
KO_DONT_OPTIMIZE=1 $CC -c $ROOTDIR/driver/StandaloneFuzzTargetMain.c -fPIC -o /driver.o
ar r /driver.a /driver.o
cp /driver.a /usr/lib/libFuzzingEngine.a

# build targ prog
$CXX $CXXFLAGS -std=c++11 "$ROOTDIR/$CODENAME/prep/target.cc" -I include .libs/libxml2.a /usr/lib/libFuzzingEngine.a -o "$TARG_DIR/xml"