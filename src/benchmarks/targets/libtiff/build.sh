#!/bin/bash
MODE=${1}
CODENAME="libtiff"

ROOTDIR="/data/src/benchmarks/targets"
MODENAME="${MODE}_targets"
TARG_DIR="$ROOTDIR/$CODENAME/$MODENAME"
rm -rf "$TARG_DIR"
mkdir -p "$TARG_DIR"

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

WORK=`pwd`/work
rm -rf $WORK
mkdir -p $WORK/lib
mkdir -p $WORK/include

./autogen.sh
./configure --disable-shared --disable-jbig --prefix="$WORK" --host=x86_64
make -j$(nproc) clean
make -j$(nproc)
make install


rm /driver.o
rm /driver.a
rm /usr/lib/libFuzzingEngine.a

# build driver
KO_DONT_OPTIMIZE=1 $CC -c $ROOTDIR/driver/StandaloneFuzzTargetMain.c -fPIC -o /driver.o
ar r /driver.a /driver.o
cp /driver.a /usr/lib/libFuzzingEngine.a


# cp "$WORK/bin/tiffcp" "$ROOTDIR/$CODENAME/$MODENAME/"

$CXX $CXXFLAGS -std=c++11 -I$WORK/include \
    $ROOTDIR/$CODENAME/prep/tiff_read_rgba_fuzzer.cc -o $ROOTDIR/$CODENAME/$MODENAME/tiff_read_rgba_fuzzer \
    $WORK/lib/libtiffxx.a $WORK/lib/libtiff.a /usr/lib/libFuzzingEngine.a \
    -lz -ljpeg -Wl,-Bstatic -llzma -Wl,-Bdynamic