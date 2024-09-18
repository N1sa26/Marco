#!/bin/bash
MODE=${1}
CODENAME="binutils"

ROOTDIR="/data/src/benchmarks/targets"
MODENAME="${MODE}_targets"
TARG_DIR="$ROOTDIR/$CODENAME/$MODENAME"
rm -rf "$TARG_DIR"
mkdir -p "$TARG_DIR"

if [ "$MODE" == "ce" ]; then
    export CC="/data/src/CE/bin/ko-clang"
    export KO_CC=clang-6.0
    export KO_CXX=clang++-6.0
    export KO_DONT_OPTIMIZE=1
fi 

if [ "$MODE" == "cov" ]; then
    export CC=clang-6.0
    export CXX=clang++-6.0
    export CFLAGS="-fsanitize-coverage=edge,no-prune,trace-pc-guard -fsanitize=address"
    export CXXFLAGS="-fsanitize-coverage=edge,no-prune,trace-pc-guard -fsanitize=address"
fi

if [ "$MODE" == "afl" ]; then
    export CC="/data/src/AFLplusplus/afl-clang"
fi 

./configure --disable-shared
make -j

mkdir ${MODE}_targets
for targ in "objdump" "nm-new" "readelf" "size"; do
    cp binutils/$targ ${MODE}_targets/$targ
done

make clean
rm -rf $TARG_DIR
cp -r ${MODE}_targets $TARG_DIR
