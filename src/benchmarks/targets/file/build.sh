#!/bin/bash
MODE=${1}
CODENAME="file"

ROOTDIR="/data/src/benchmarks/targets"
MODENAME="${MODE}_targets"
TARG_DIR="$ROOTDIR/$CODENAME/$MODENAME"
rm -rf "$TARG_DIR"
mkdir -p "$TARG_DIR"

make distclean

if [ "$MODE" == "ce" ]; then
    export CC="/data/src/CE/bin/ko-clang"
    export CXX="/data/src/CE/bin/ko-clang++"
    export KO_CC="clang-6.0"
    export KO_CXX="clang++-6.0"
    export KO_DONT_OPTIMIZE=1
    export CFLAGS="-O -DHAVE_CONFIG_H -Wall"        # important!
fi 

if [ "$MODE" == "cov" ]; then
    export CC=clang-6.0
    export CXX=clang++-6.0
    export CFLAGS="-O -DHAVE_CONFIG_H -Wall -fsanitize-coverage=edge,no-prune,trace-pc-guard -fsanitize=address"
    export CXXFLAGS="-O -DHAVE_CONFIG_H -Wall -fsanitize-coverage=edge,no-prune,trace-pc-guard -fsanitize=address"
fi 

if [ "$MODE" == "afl" ]; then
    export CC="/data/src/AFLplusplus/afl-clang"
    export CXX="/data/src/AFLplusplus/afl-clang++"
    export CFLAGS="-O -DHAVE_CONFIG_H -Wall"
fi 


autoreconf -i
./configure --enable-static --host=x86_64 --disable-xzlib --disable-zlib
make all -j


rm /driver.o
rm /driver.a
rm /usr/lib/libFuzzingEngine.a

# build driver
KO_DONT_OPTIMIZE=1 $CC -c $ROOTDIR/driver/StandaloneFuzzTargetMain.c -fPIC -o /driver.o
ar r /driver.a /driver.o
cp /driver.a /usr/lib/libFuzzingEngine.a

"$CC" $CFLAGS -I src -I . \
     "fuzz/magic_fuzzer.c" -o "$ROOTDIR/$CODENAME/$MODENAME/magic_fuzzer" \
      src/.libs/libmagic.a /usr/lib/libFuzzingEngine.a

cp magic/magic.mgc "$ROOTDIR/$CODENAME/$MODENAME/magic.mgc"
