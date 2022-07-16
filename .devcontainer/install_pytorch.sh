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
if [ $cuda_major -eq 10 ] && [ $cuda_minor -eq 0 ]; then
	pip3 install torch==1.4.0 torchvision==0.5.0 -f https://download.pytorch.org/whl/cu100/torch_stable.html
elif [ $cuda_major -eq 10 ] && [ $cuda_minor -eq 2 ]; then
	pip3 install torch==1.8.1 torchvision==0.9.1 torchaudio==0.8.1
elif [ $cuda_major -eq 11 ] && [ $cuda_minor -eq 0 ]; then
	pip3 install torch==1.8.1+cu110 torchvision==0.9.1+cu110 torchaudio==0.8.1+cu110
elif [ $cuda_major -eq 11 ] && [ $cuda_minor -eq 1 ]; then
	pip3 install --no-cache-dir torch==1.8.1+cu111 torchvision==0.9.1+cu111 torchaudio==0.8.1 -f https://download.pytorch.org/whl/torch_stable.html
elif [ $cuda_major -eq 11 ] && [ $cuda_minor -eq 3 ]; then
	pip3 install --no-cache-dir torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu113
else
	exit 1
fi
