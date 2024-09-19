#!/bin/bash 

############################ binutils: size/nm-new/readelf/objdump ############################

# # ------------------------- Step 1: download source code ------------------------- #
# CODENAME="binutils-2.33.1"
# if [ ! -d "./${CODENAME}" ]; then
#     wget https://ftp.gnu.org/gnu/binutils/binutils-2.33.1.tar.gz
#     tar -xvf binutils-2.33.1.tar.gz
#     rm binutils-2.33.1.tar.gz
# fi

# # ------------------------- step 2: build targets (MODE: ce/cov/afl) ------------- #
# MODE="ce"
# rm -rf ${CODENAME}_${MODE}
# cp -r ${CODENAME} ${CODENAME}_${MODE}
# cp `pwd`/targets/${CODENAME}/build.sh ${CODENAME}_${MODE}
# pushd ${CODENAME}_${MODE}
#     bash build.sh $MODE
# popd 

############################ libxml2-v2.9.2: xml ############################

# # ------------------------- Step 1: download source code ------------------------- #
# CODENAME="libxml2-v2.9.2"
# if [ ! -d "./${CODENAME}" ]; then
#     git clone https://gitlab.gnome.org/GNOME/libxml2.git libxml2-v2.9.2
#     pushd ${CODENAME}
#         git checkout -f v2.9.2
#     popd 
# fi 

# # ------------------------- step 2: build targets (MODE: ce/cov/afl) ------------- #
# MODE="ce"
# rm -rf ${CODENAME}_${MODE}
# cp -r ${CODENAME} ${CODENAME}_${MODE}
# cp `pwd`/targets/${CODENAME}/build.sh ${CODENAME}_${MODE}
# pushd ${CODENAME}_${MODE}
#     bash build.sh $MODE
# popd 

############################ lcms: cms_transform_fuzzer ############################

# # ------------------------- Step 1: download source code ------------------------- #
# CODENAME="lcms"
# if [ ! -d "./${CODENAME}" ]; then
#     mkdir ${CODENAME}
#     pushd ${CODENAME}
#         git clone https://github.com/mm2/Little-CMS.git     
#         pushd Little-CMS
#             git config --global --add safe.directory `pwd`
#             git checkout f9d75ccef0b54c9f4167d95088d4727985133c52
#             cp `pwd`/../../targets/lcms/cms_transform_fuzzer.cc ./
#         popd
#     popd
# fi 

# # ------------------------- step 2: build targets (MODE: ce/cov/afl) ------------- #
# # note: cms_transform_fuzzer.cc is obtained from fuzzbench
# MODE="ce"
# rm -rf ${CODENAME}_${MODE}
# cp -r ${CODENAME} ${CODENAME}_${MODE}
# cp `pwd`/targets/${CODENAME}/build.sh ${CODENAME}_${MODE}
# pushd ${CODENAME}_${MODE}
#     bash build.sh $MODE
# popd 

############################ file: magic_fuzzer ############################

# # ------------------------- Step 1: download source code ------------------------- #
# CODENAME="file"
# if [ ! -d "./${CODENAME}" ]; then
#     git clone https://github.com/file/file.git ${CODENAME}
#     cd ${CODENAME}
#     git checkout FILE5_42
#     cd ..
# fi 

# # ------------------------- step 2: build targets (MODE: ce/cov/afl) ------------- #
# MODE="ce"
# rm -rf ${CODENAME}_${MODE}
# cp -r ${CODENAME} ${CODENAME}_${MODE}
# cp `pwd`/targets/${CODENAME}/build.sh ${CODENAME}_${MODE}
# pushd ${CODENAME}_${MODE}
#     bash build.sh $MODE
# popd 

############################ vorbis: decode_fuzzer ############################

# # ------------------------- Step 1: download source code ------------------------- #
# CODENAME="vorbis"
# if [ ! -d "./${CODENAME}" ]; then
#     mkdir ${CODENAME}
#     cd ${CODENAME}
#         git clone https://github.com/xiph/ogg.git
#         git clone https://github.com/xiph/vorbis.git
#         wget -qO ./decode_fuzzer.cc https://raw.githubusercontent.com/google/oss-fuzz/688aadaf44499ddada755562109e5ca5eb3c5662/projects/vorbis/decode_fuzzer.cc
#     cd ../
# fi 

# # ------------------------- step 2: build targets (MODE: ce/cov/afl) ------------- #
# MODE="ce"
# rm -rf ${CODENAME}_${MODE}
# cp -r ${CODENAME} ${CODENAME}_${MODE}
# cp `pwd`/targets/${CODENAME}/build.sh ${CODENAME}_${MODE}
# pushd ${CODENAME}_${MODE}
#     bash build.sh $MODE
# popd 

############################ curl: curl_fuzzer_http ############################

# # ------------------------- Step 1: download source code ------------------------- #
# CODENAME="curl"
# if [ ! -d "./${CODENAME}" ]; then
#     mkdir ${CODENAME}
#     cd ${CODENAME}
#         git clone --depth 1 https://github.com/curl/curl.git curl
#         git clone https://github.com/curl/curl-fuzzer.git curl_fuzzer
#         git -C curl_fuzzer checkout -f 9a48d437484b5ad5f2a97c0cab0d8bcbb5d058de
#         cp ../targets/curl/download_zlib.sh ./curl_fuzzer/scripts/download_zlib.sh  # coz the original downloading url is deprecated
#         cp ../targets/curl/install_curl.sh ./curl_fuzzer/scripts/install_curl.sh    # added --without-libpsl 
#     cd ..
# fi 

# # ------------------------- step 2: build targets (MODE: ce/cov/afl) ------------- #
# MODE="ce"
# rm -rf ${CODENAME}_${MODE}
# cp -r ${CODENAME} ${CODENAME}_${MODE}
# cp `pwd`/targets/${CODENAME}/build.sh ${CODENAME}_${MODE}
# pushd ${CODENAME}_${MODE}
#     bash build.sh $MODE
# popd 

############################ woff: convert_woff2ttf_fuzzer ############################

# # ------------------------- Step 1: download source code ------------------------- #
# CODENAME="woff"
# if [ ! -d "./${CODENAME}" ]; then
#     mkdir ${CODENAME} 
#     cd ${CODENAME}
#         git clone https://github.com/google/woff2.git
#         git clone https://github.com/google/brotli.git
#         git clone https://github.com/google/oss-fuzz.git
#         cp ../targets/woff/target.cc ./
#     cd ..
# fi 

# # ------------------------- step 2: build targets (MODE: ce/cov/afl) ------------- #
# MODE="ce"
# rm -rf ${CODENAME}_${MODE}
# cp -r ${CODENAME} ${CODENAME}_${MODE}
# cp `pwd`/targets/${CODENAME}/build.sh ${CODENAME}_${MODE}
# pushd ${CODENAME}_${MODE}
#     bash build.sh $MODE
# popd 

############################ libjpeg-turbo: libjpeg_turbo_fuzzer ############################

# # ------------------------- Step 1: download source code ------------------------- #
# CODENAME="libjpeg-turbo"
# if [ ! -d "./${CODENAME}" ]; then
#     git clone https://github.com/libjpeg-turbo/libjpeg-turbo.git
# fi 

# # ------------------------- step 2: build targets (MODE: ce/cov/afl) ------------- #
# MODE="ce"
# rm -rf ${CODENAME}_${MODE}
# cp -r ${CODENAME} ${CODENAME}_${MODE}
# cp `pwd`/targets/${CODENAME}/build.sh ${CODENAME}_${MODE}
# pushd ${CODENAME}_${MODE}
#     bash build.sh $MODE
# popd 

############################ sqlite3: ossfuzz ############################

# # ------------------------- Step 1: download source code ------------------------- #
# CODENAME="sqlite3"
# if [ ! -d "./${CODENAME}" ]; then
#     apt-get update && apt-get install -y make autoconf automake libtool curl tcl zlib1g-dev

#     mkdir ${CODENAME}
#     cd ${CODENAME}
#     curl 'https://sqlite.org/src/tarball/sqlite.tar.gz?r=c78cbf2e86850cc6' -o sqlite3.tar.gz && \
#             tar xzf sqlite3.tar.gz --strip-components 1
#     cd ../
# fi 

# # ------------------------- step 2: build targets (MODE: ce/cov/afl) ------------- #
# MODE="ce"
# rm -rf ${CODENAME}_${MODE}
# cp -r ${CODENAME} ${CODENAME}_${MODE}
# cp `pwd`/targets/${CODENAME}/build.sh ${CODENAME}_${MODE}
# pushd ${CODENAME}_${MODE}
#     bash build.sh $MODE
# popd 

############################ tcpdump ############################

# # ------------------------- Step 1: download source code ------------------------- #
# CODENAME=""
# if [ ! -d "./${CODENAME}" ]; then
    
# fi 

# # ------------------------- step 2: build targets (MODE: ce/cov/afl) ------------- #
# MODE="ce"
# rm -rf ${CODENAME}_${MODE}
# cp -r ${CODENAME} ${CODENAME}_${MODE}
# cp `pwd`/targets/${CODENAME}/build.sh ${CODENAME}_${MODE}
# pushd ${CODENAME}_${MODE}
#     bash build.sh $MODE
# popd 


############################ ftfuzzer ############################

# # ------------------------- Step 1: download source code ------------------------- #
# CODENAME=""
# if [ ! -d "./${CODENAME}" ]; then
    
# fi 

# # ------------------------- step 2: build targets (MODE: ce/cov/afl) ------------- #
# MODE="ce"
# rm -rf ${CODENAME}_${MODE}
# cp -r ${CODENAME} ${CODENAME}_${MODE}
# cp `pwd`/targets/${CODENAME}/build.sh ${CODENAME}_${MODE}
# pushd ${CODENAME}_${MODE}
#     bash build.sh $MODE
# popd 

############################ tiff_read_rgba_fuzzer ############################

# # ------------------------- Step 1: download source code ------------------------- #
# CODENAME=""
# if [ ! -d "./${CODENAME}" ]; then
    
# fi 

# # ------------------------- step 2: build targets (MODE: ce/cov/afl) ------------- #
# MODE="ce"
# rm -rf ${CODENAME}_${MODE}
# cp -r ${CODENAME} ${CODENAME}_${MODE}
# cp `pwd`/targets/${CODENAME}/build.sh ${CODENAME}_${MODE}
# pushd ${CODENAME}_${MODE}
#     bash build.sh $MODE
# popd 

############################ libpng_read_fuzzer ############################

# # ------------------------- Step 1: download source code ------------------------- #
# CODENAME=""
# if [ ! -d "./${CODENAME}" ]; then
    
# fi 

# # ------------------------- step 2: build targets (MODE: ce/cov/afl) ------------- #
# MODE="ce"
# rm -rf ${CODENAME}_${MODE}
# cp -r ${CODENAME} ${CODENAME}_${MODE}
# cp `pwd`/targets/${CODENAME}/build.sh ${CODENAME}_${MODE}
# pushd ${CODENAME}_${MODE}
#     bash build.sh $MODE
# popd 

