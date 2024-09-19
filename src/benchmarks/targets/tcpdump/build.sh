#!/bin/bash
MODE=${1}
CODENAME="tcpdump"

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

if [ "$MODE" == "afl" ]; then
    export CC="/data/src/AFLplusplus/afl-clang-fast"
    export CXX="/data/src/AFLplusplus/afl-clang-fast++"
fi 

# 1. build libpcap
pushd libpcap
./autogen.sh
./configure --disable-shared
make -j
popd 

# 2. build tcpdump 
pushd tcpdump-4.99.1
./configure --disable-shared
make -j
popd 

cp tcpdump-4.99.1/tcpdump $ROOTDIR/$CODENAME/$MODENAME/
