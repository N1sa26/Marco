#!/bin/bash
MODE=${1}
CODENAME="curl"

ROOTDIR="/data/src/benchmarks/targets"
MODENAME="${MODE}_targets"
TARG_DIR="$ROOTDIR/$CODENAME/$MODENAME"
rm -rf "$TARG_DIR"
mkdir -p "$TARG_DIR"

apt-get update
apt-get install -y make \
    autoconf \
    automake \
    libtool \
    libssl-dev \
    zlib1g-dev \
    pkg-config \
    wget \
    zip

# sudo apt-get install libpsl-dev 

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
    export CC="/data/src/AFLplusplus/afl-cc"
    export CXX="/data/src/AFLplusplus/afl-cc"
fi 

rm /driver.o
rm /driver.a
rm /usr/lib/libFuzzingEngine.a

# build driver
KO_DONT_OPTIMIZE=1 $CC -c $ROOTDIR/driver/StandaloneFuzzTargetMain.c -fPIC -o /driver.o
ar r /driver.a /driver.o
cp /driver.a /usr/lib/libFuzzingEngine.a

export LIB_FUZZING_ENGINE=/driver.a

# build the library fuzz target 
cd curl_fuzzer

export BUILD_ROOT=$PWD
SCRIPTDIR=${BUILD_ROOT}/scripts

. ${SCRIPTDIR}/fuzz_targets

ZLIBDIR=`pwd`/../zlib
OPENSSLDIR=`pwd`/../openssl
NGHTTPDIR=`pwd`/../nghttp2

echo "CC: $CC"
echo "CXX: $CXX"
echo "LIB_FUZZING_ENGINE: $LIB_FUZZING_ENGINE"
echo "CFLAGS: $CFLAGS"
echo "CXXFLAGS: $CXXFLAGS"
echo "ARCHITECTURE: $ARCHITECTURE"
echo "FUZZ_TARGETS: $FUZZ_TARGETS"
echo "SANITIZER: ${SANITIZER}"

export MAKEFLAGS+="-j$(nproc)"

# Make an install directory
export INSTALLDIR=`pwd`/../curl_install

# Install zlib
${SCRIPTDIR}/handle_x.sh zlib ${ZLIBDIR} ${INSTALLDIR} || exit 1

# For the memory sanitizer build, turn off OpenSSL as it causes bugs we can't
# affect (see 16697, 17624)
if [[ ${SANITIZER} != "memory" ]]
then
    # Install openssl
    export OPENSSLFLAGS="-fno-sanitize=alignment no-asm"
    ${SCRIPTDIR}/handle_x.sh openssl ${OPENSSLDIR} ${INSTALLDIR} || exit 1
fi

# Install nghttp2
${SCRIPTDIR}/handle_x.sh nghttp2 ${NGHTTPDIR} ${INSTALLDIR} || exit 1

# # Compile curl
${SCRIPTDIR}/install_curl.sh `pwd`/../curl ${INSTALLDIR}

# Build the fuzzers.
${SCRIPTDIR}/compile_fuzzer.sh ${INSTALLDIR}
make zip


# Copy the fuzzers over.
for TARGET in $FUZZ_TARGETS 
do
  cp -v ${TARGET} ${TARGET}_seed_corpus.zip  $ROOTDIR/$CODENAME/$MODENAME/
done

# Copy dictionary and options file to $OUT.
cp -v ossconfig/*.dict ossconfig/*.options $ROOTDIR/$CODENAME/$MODENAME/
