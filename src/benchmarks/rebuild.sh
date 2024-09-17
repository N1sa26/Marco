#!/bin/bash 

############################ size/nm-new/readelf/objdump ############################

if [ ! -d "./binutils-2.33.1" ]; then
    wget https://ftp.gnu.org/gnu/binutils/binutils-2.33.1.tar.gz
    tar -xvf binutils-2.33.1.tar.gz
    rm binutils-2.33.1.tar.gz
fi

MODE="ce"   # or use "cov" to build SanCov targets
cp -r ./binutils-2.33.1 ./binutils-2.33.1_${MODE}
cp `pwd`/targets/binutils/build.sh binutils-2.33.1_${MODE}
pushd binutils-2.33.1_${MODE}
    bash build.sh ${MODE}
popd

############################ libxml2 ############################

if [ ! -d "./libxml2-v2.9.2" ]; then
    git clone https://gitlab.gnome.org/GNOME/libxml2.git libxml2-v2.9.2
    pushd libxml2-v2.9.2
        git checkout -f v2.9.2
    popd 
fi 

MODE="ce" # or use "cov" to build SanCov targets
cp -r libxml2-v2.9.2 libxml2-v2.9.2_${MODE}
cp `pwd`/targets/libxml2-v2.9.2/build.sh libxml2-v2.9.2_${MODE}

pushd libxml2-v2.9.2_${MODE}
    bash build.sh $MODE
popd



# "xml" 
# "cms_transform_fuzzer" 
# "magic_fuzzer" 
# "decode_fuzzer" 
# "curl_fuzzer_http" 
# "convert_woff2ttf_fuzzer" 
# "libjpeg_turbo_fuzzer" 
# "ossfuzz" 
# "tcpdump" 
# "ftfuzzer" 
# "tiff_read_rgba_fuzzer" 
# "libpng_read_fuzzer" 