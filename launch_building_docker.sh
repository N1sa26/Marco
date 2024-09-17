#!/bin/bash
DOCKERNAME="marco_build"
DKIMG="marco_design"

docker stop $DOCKERNAME
docker rm $DOCKERNAME

docker run --name $DOCKERNAME \
        -v `pwd`/src/benchmarks:/data/src/benchmarks \
        -v `pwd`/src/CE:/data/src/CE \
        -ti $DKIMG /bin/bash