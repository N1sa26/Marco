#!/bin/bash
MODE=${1}
CODENAME="woff"

echo $MODE $CODENAME
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
    libtool

cd oss-fuzz
git config --global --add safe.directory `pwd`
git checkout e8ffee4077b59e35824a2e97aa214ee95d39ed13
if [ ! -d "$ROOTDIR/$CODENAME/seed" ]; then
    mkdir -p $ROOTDIR/$CODENAME/seed
    cp projects/woff2/corpus/* $ROOTDIR/$CODENAME/seed
fi 
cd ..

cd brotli
git config --global --add safe.directory `pwd`
git checkout 3a9032ba8733532a6cd6727970bade7f7c0e2f52
cd ..

cd woff2
git config --global --add safe.directory `pwd`
git checkout 9476664fd6931ea6ec532c94b816d8fbbe3aed90

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


for f in font.cc normalize.cc transform.cc woff2_common.cc woff2_dec.cc \
         woff2_enc.cc glyph.cc table_tags.cc variable_length.cc woff2_out.cc; do
  $CXX $CXXFLAGS -std=c++11 -I ../brotli/dec -I ../brotli/enc -c src/$f &
done
for f in ../brotli/dec/*.c ../brotli/enc/*.cc; do
  $CXX $CXXFLAGS -c $f &
done
wait

rm /driver.o
rm /driver.a
rm /usr/lib/libFuzzingEngine.a

# build driver
KO_DONT_OPTIMIZE=1 $CC -c $ROOTDIR/driver/StandaloneFuzzTargetMain.c -fPIC -o /driver.o
ar r /driver.a /driver.o
cp /driver.a /usr/lib/libFuzzingEngine.a

$CXX $CXXFLAGS *.o /usr/lib/libFuzzingEngine.a ../target.cc -I src \
    -o $ROOTDIR/$CODENAME/$MODENAME/convert_woff2ttf_fuzzer

