#!/bin/bash
MODE=${1}
CODENAME="freetype"

ROOTDIR="/data/src/benchmarks/targets"
MODENAME="${MODE}_targets"
TARG_DIR="$ROOTDIR/$CODENAME/$MODENAME"
rm -rf "$TARG_DIR"
mkdir -p "$TARG_DIR"


apt-get update &&  \
    apt-get install -y \
    make \
    autoconf \
    libtool \
    wget


if [ "$MODE" == "ce" ]; then
    export CC="/data/src/CE/bin/ko-clang"
    export CXX="/data/src/CE/bin/ko-clang++"
    export KO_CC="clang-6.0"
    export KO_CXX="clang++-6.0"
    export KO_DONT_OPTIMIZE=1
fi 


if [ "$MODE" == "cov" ]; then
    export CC=clang-6.0
    export CXX=clang++-6.0
    export CFLAGS="-fsanitize-coverage=edge,no-prune,trace-pc-guard -fsanitize=address"
    export CXXFLAGS="-fsanitize-coverage=edge,no-prune,trace-pc-guard -fsanitize=address"

fi 

# if [ "$MODE" == "afl" ]; then

# fi 


tar xf libarchive-3.4.3.tar.xz
cd libarchive-3.4.3
./configure --disable-shared --with-lzma=no
make clean
make -j $(nproc)
make install
cd ..

git config --global --add safe.directory `pwd`/freetype2
cd freetype2
git checkout cd02d359a6d0455e9d16b87bf9665961c4699538
./autogen.sh
./configure --with-harfbuzz=no --with-bzip2=no --with-png=no --without-zlib
make clean
make all -j $(nproc)

rm /driver.o
rm /driver.a
rm /usr/lib/libFuzzingEngine.a

# build driver
KO_DONT_OPTIMIZE=1 $CC -c $ROOTDIR/driver/StandaloneFuzzTargetMain.c -fPIC -o /driver.o
ar r /driver.a /driver.o
cp /driver.a /usr/lib/libFuzzingEngine.a

$CXX $CXXFLAGS -std=c++11 -I include -I . src/tools/ftfuzzer/ftfuzzer.cc \
    objs/.libs/libfreetype.a /usr/lib/libFuzzingEngine.a -L /usr/local/lib -larchive \
    -o $ROOTDIR/$CODENAME/$MODENAME/ftfuzzer
