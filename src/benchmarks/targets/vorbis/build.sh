#!/bin/bash
MODE=${1}
CODENAME="vorbis"

ROOTDIR="/data/src/benchmarks/targets"
MODENAME="${MODE}_targets"
TARG_DIR="$ROOTDIR/$CODENAME/$MODENAME"
rm -rf "$TARG_DIR"
mkdir -p "$TARG_DIR"

apt-get update && \
    apt-get install -y \
    make \
    automake \
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

if [ "$MODE" == "afl" ]; then
    export CC="/data/src/AFLplusplus/afl-clang-fast"
    export CXX="/data/src/AFLplusplus/afl-clang-fast++"
fi

readonly INSTALL_DIR="$PWD/INSTALL"
mkdir -p INSTALL

cd ogg
git checkout c8391c2b267a7faf9a09df66b1f7d324e9eb7766
./autogen.sh
./configure \
    --prefix="$INSTALL_DIR" \
    --enable-static \
    --disable-shared \
    --disable-crc
make -j $(nproc)
make install
cd ..

cd vorbis
git checkout c1c2831fc7306d5fbd7bc800324efd12b28d327f
./autogen.sh
./configure \
    --prefix="$INSTALL_DIR" \
    --enable-static \
    --disable-shared
make -j $(nproc)
make install
cd ..


rm /driver.o
rm /driver.a
rm /usr/lib/libFuzzingEngine.a

# build driver
KO_DONT_OPTIMIZE=1 $CC -c $ROOTDIR/driver/StandaloneFuzzTargetMain.c -fPIC -o /driver.o
ar r /driver.a /driver.o
cp /driver.a /usr/lib/libFuzzingEngine.a

$CXX $CXXFLAGS -std=c++11 decode_fuzzer.cc \
    -o $ROOTDIR/$CODENAME/$MODENAME/decode_fuzzer -L"$INSTALL_DIR/lib" -I"$INSTALL_DIR/include" \
    /driver.a -lvorbisfile -lvorbis -logg