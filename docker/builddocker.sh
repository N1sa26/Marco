#!/bin/bash
NCACHE=${1}
if [ -z "$NCACHE" ]; then
    echo "docker build --network=host -f ./Dockerfile -t marco_design . "
    docker build --network=host -f ./Dockerfile -t marco_design .
else
    echo "docker build --network=host --no-cache -f ./Dockerfile -t marco_design . "
    docker build --network=host --no-cache -f ./Dockerfile -t marco_design .
fi
