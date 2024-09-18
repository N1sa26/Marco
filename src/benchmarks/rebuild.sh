#!/bin/bash 

############################ size/nm-new/readelf/objdump ############################

# if [ ! -d "./binutils-2.33.1" ]; then
#     wget https://ftp.gnu.org/gnu/binutils/binutils-2.33.1.tar.gz
#     tar -xvf binutils-2.33.1.tar.gz
#     rm binutils-2.33.1.tar.gz
# fi

# MODE="ce"   # or cov, or afl
# cp -r ./binutils-2.33.1 ./binutils-2.33.1_${MODE}
# cp `pwd`/targets/binutils/build.sh binutils-2.33.1_${MODE}
# pushd binutils-2.33.1_${MODE}
#     bash build.sh ${MODE}
# popd

############################ libxml2 ############################

# if [ ! -d "./libxml2-v2.9.2" ]; then
#     git clone https://gitlab.gnome.org/GNOME/libxml2.git libxml2-v2.9.2
#     pushd libxml2-v2.9.2
#         git checkout -f v2.9.2
#     popd 
# fi 

# MODE="ce" # or cov, or afl
# cp -r libxml2-v2.9.2 libxml2-v2.9.2_${MODE}
# cp `pwd`/targets/libxml2-v2.9.2/build.sh libxml2-v2.9.2_${MODE}

# pushd libxml2-v2.9.2_${MODE}
#     bash build.sh $MODE
# popd

############################ cms_transform_fuzzer ############################
if [ ! -d "./lcms" ]; then
    mkdir lcms
    pushd lcms
        git clone https://github.com/mm2/Little-CMS.git     
        pushd Little-CMS
            git config --global --add safe.directory `pwd`
            git checkout f9d75ccef0b54c9f4167d95088d4727985133c52
            cp `pwd`/../../targets/lcms/cms_transform_fuzzer.cc ./
        popd
    popd
fi 

# note: cms_transform_fuzzer.cc is obtained from fuzzbench
MODE="ce"
cp -r lcms lcms_${MODE}
cp `pwd`/targets/lcms/build.sh lcms_${MODE}

pushd lcms_${MODE}
    bash build.sh $MODE
popd 

