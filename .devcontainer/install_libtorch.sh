#!/bin/bash
set -e

# taken from https://github.com/cloudflare/semver_bash
function semverParseInto() {
    local RE='[^0-9]*\([0-9]*\)[.]\([0-9]*\)[.]\([0-9]*\)\([0-9A-Za-z-]*\)'
    #MAJOR
    eval $2=`echo $1 | sed -e "s#$RE#\1#"`
    #MINOR
    eval $3=`echo $1 | sed -e "s#$RE#\2#"`
    #MINOR
    eval $4=`echo $1 | sed -e "s#$RE#\3#"`
    #SPECIAL
    eval $5=`echo $1 | sed -e "s#$RE#\4#"`
}

semverParseInto $CUDA_VERSION cuda_major cuda_minor cuda_patch cuda_special
echo "$CUDA_VERSION -> M: $cuda_major m:$cuda_minor p:$cuda_patch s:$cuda_special"

mkdir -p ~/3rdparty && cd ~/3rdparty
# Install libtorch
if [ $cuda_major -eq 10 ] && [ $cuda_minor -eq 2 ]; then
	wget -q --show-progress --progress=bar:force:noscroll https://download.pytorch.org/libtorch/cu102/libtorch-cxx11-abi-shared-with-deps-1.7.1.zip
	unzip libtorch-cxx11-abi-shared-with-deps-1.7.1.zip
	rm libtorch-cxx11-abi-shared-with-deps-1.7.1.zip
elif [ $cuda_major -eq 11 ] && [ $cuda_minor -eq 0 ]; then
	wget -q --show-progress --progress=bar:force:noscroll https://download.pytorch.org/libtorch/cu110/libtorch-cxx11-abi-shared-with-deps-1.7.1%2Bcu110.zip
	unzip libtorch-cxx11-abi-shared-with-deps-1.7.1+cu110.zip
	rm libtorch-cxx11-abi-shared-with-deps-1.7.1+cu110.zip
elif [ $cuda_major -eq 11 ] && [ $cuda_minor -eq 1 ]; then
	wget -q --show-progress --progress=bar:force:noscroll https://download.pytorch.org/libtorch/cu111/libtorch-cxx11-abi-shared-with-deps-1.8.1%2Bcu111.zip
	unzip libtorch-cxx11-abi-shared-with-deps-1.8.1+cu111.zip
	rm libtorch-cxx11-abi-shared-with-deps-1.8.1+cu111.zip
fi
cp -r libtorch/* /usr/
rm libtorch -rf
