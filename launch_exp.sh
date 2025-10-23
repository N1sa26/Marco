#!/bin/bash

###############################################
###   Experiment Configuration Zone --- BEGIN
###############################################
CPU_ID=0                # which CPU core to pin on, default to 0

START=0                 # launch 1 trial from id 0
END=1

OROOT=`pwd`/exp_test    # root directory of experiment data
TIMEOUT="5m"            # timeout - 5 minutes
DKIMG="marco_design"    #

declare -a TARG=(       # list of realworld targets - only libpng
    # "size" \
    # "nm-new" \
    # "readelf"  \
    # "objdump" \
    # "xml" \
    # "cms_transform_fuzzer" \
    # "magic_fuzzer" \
    # "decode_fuzzer" \
    # "curl_fuzzer_http" \
    # "convert_woff2ttf_fuzzer" \
    # "libjpeg_turbo_fuzzer" \
    # "ossfuzz" \
    # "tcpdump" \
    # "ftfuzzer" \
    # "tiff_read_rgba_fuzzer" \
    "libpng_read_fuzzer" \
)

###############################################
###   Experiment Configuratino Zone --- END
###############################################

echo "======================= launching experiments ======================="
echo "* Experiment root directory:    $OROOT"
echo "* Time budget for each trial:   $TIMEOUT"
echo "* Starting from CPU core:       $CPU_ID"
echo "* Using docker image:           $DKIMG"

mkdir -p "$OROOT"

for PROGRAM in "${TARG[@]}"; do
    TRIAL=$START
    while [ $TRIAL -ne $END ]; do
        DOCKERNAME="${DKIMG}_${PROGRAM}_${TRIAL}"
        DATADIR="$OROOT/${PROGRAM}_${TRIAL}"

        echo "launched on CPU"${CPU_ID} "for" $TIMEOUT " === docker_container: "$DOCKERNAME "@ "$DATADIR
        docker stop $DOCKERNAME
        docker rm $DOCKERNAME

        sudo rm -rf $DATADIR
        mkdir -p $DATADIR

        docker run --ulimit core=0 -d --name $DOCKERNAME \
                --cpuset-cpus "${CPU_ID}" \
                -v $DATADIR:/outroot \
                -v `pwd`/src/benchmarks/targets:/workdir/targets \
                -v `pwd`/src/CE:/data/src/CE \
                -v `pwd`/src/scheduler/main.py:/data/src/scheduler/main.py \
                -v `pwd`/run.sh:/workdir/run.sh \
                $DKIMG timeout $TIMEOUT /bin/bash run.sh $TRIAL $PROGRAM
        TRIAL=$(($TRIAL+1))
        CPU_ID=$((CPU_ID+1))
    done
    echo ""
done
