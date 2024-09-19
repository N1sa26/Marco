#!/bin/bash
TRIAL=${1}
PROGRAM=${2}

export LD_LIBRARY_PATH=/usr/local/lib
export PATH=$PATH:/usr/local/lib

# cleanup stuff:
rm -rf /tmp/wp2
rm -rf /tmp/wp3
mkfifo /tmp/wp2
mkfifo /tmp/wp3

# for grader & tracer communication [depr?]
rm -rf /tmp/myfifo
rm -rf /tmp/pcpipe
mkfifo /tmp/myfifo
mkfifo /tmp/pcpipe

rm -rf /dev/shm/sem.fuzzer
rm -rf /dev/shm/sem.ce
rm -rf /dev/shm/sem.grader

declare -A OPT=(
    ["objdump"]="-D" \
    ["readelf"]="-a" \
    ["nm-new"]="-C" \
    ["tcpdump"]="-r" \
)

declare -A TARGDIR=(
    ["objdump"]="binutils" \
    ["size"]="binutils" \
    ["readelf"]="binutils" \
    ["nm-new"]="binutils" \
    ["xml"]="libxml2-v2.9.2" \
    ["cms_transform_fuzzer"]="lcms" \
    ["magic_fuzzer"]="file" \
    ["decode_fuzzer"]="vorbis" \
    ["curl_fuzzer_http"]="curl" \
    ["convert_woff2ttf_fuzzer"]="woff" \
    ["libjpeg_turbo_fuzzer"]="libjpeg-turbo" \
    ["ossfuzz"]="sqlite3" \
    ["tcpdump"]="tcpdump-4.99.1" \
    ["ftfuzzer"]="freetype" \
    ["tiff_read_rgba_fuzzer"]="libtiff" \
    ["libpng_read_fuzzer"]="libpng-1.2.56" \
)


OUT="/outroot"
INPUT="/workdir/input"
SEEDDIR="/workdir/targets/${TARGDIR[${PROGRAM}]}/seed"

if [ -d "$OUT" ]; then
    rm -rf $OUT/*
fi
cd $OUT

mkdir tmpin
tmpcount=0
for oldname in $SEEDDIR/* ; do
    newname=$(printf "id:%06d,orig\n" $tmpcount)
    cp $oldname /outroot/tmpin/$newname
    tmpcount=$((tmpcount+1))
done
SEEDDIR="/outroot/tmpin/"

mkdir -p tree tree0 tree1
mkdir -p deps pcsets

mkdir -p ce_output/queue
mkdir -p fifo/queue
mkdir -p afl-slave/queue

cp $SEEDDIR/* afl-slave/queue/

# use marco scheduler
cp /data/src/scheduler/main.py ./
cp /data/src/CE/target/release/fastgen ./

CE_TARG="/workdir/targets/${TARGDIR[${PROGRAM}]}/ce_targets/${PROGRAM}"

if [ "$PROGRAM" == "objdump" -o "$PROGRAM" == "nm-new" -o "$PROGRAM" == "readelf" -o "$PROGRAM" == "tcpdump" ]; then
    LD_PRELOAD="/usr/lib/x86_64-linux-gnu/libprotobuf.so.10" RUST_BACKTRACE=1 RUST_LOG=info ./fastgen --sync_afl -i "$INPUT" -o "$OUT" -t "$CE_TARG" -b 1 -f 1 -c 0 -- "$CE_TARG" "${OPT[${PROGRAM}]}" @@  &> run_ce.log &
else
    LD_PRELOAD="/usr/lib/x86_64-linux-gnu/libprotobuf.so.10" RUST_BACKTRACE=1 RUST_LOG=info ./fastgen --sync_afl -i "$INPUT" -o "$OUT" -t "$CE_TARG" -b 1 -f 1 -c 0 -- "$CE_TARG" @@  &> run_ce.log &
fi

python3.7 main.py -d 0 -m 2 &> debug.log


# -------- for hybrid fuzzing only -------- #
# export AFL_SKIP_CPUFREQ=1
# export AFL_NO_AFFINITY=1
# export AFL_NO_UI=1