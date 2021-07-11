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
# Install tensorrt
echo 'Downloading TensorRT local deb package...'
if [ $cuda_major -eq 10 ] && [ $cuda_minor -eq 2 ]; then
    wget -q --show-progress --progress=bar:force:noscroll https://bit.ly/3dAqGEg -O nv-tensorrt-repo-ubuntu1804-cuda10.2-trt7.2.3.4-ga-20210226_1-1_amd64.deb
    dpkg -i nv-tensorrt-repo-ubuntu1804-cuda10.2-trt7.2.3.4-ga-20210226_1-1_amd64.deb
    rm nv-tensorrt-repo-ubuntu1804-cuda10.2-trt7.2.3.4-ga-20210226_1-1_amd64.deb
elif [ $cuda_major -eq 11 ] && [ $cuda_minor -eq 0 ]; then
    wget -q --show-progress  --progress=bar:force:noscroll https://bit.ly/3yjflQD -O nv-tensorrt-repo-ubuntu1804-cuda11.0-trt7.2.3.4-ga-20210226_1-1_amd64.deb
    dpkg -i nv-tensorrt-repo-ubuntu1804-cuda11.0-trt7.2.3.4-ga-20210226_1-1_amd64.deb
    rm nv-tensorrt-repo-ubuntu1804-cuda11.0-trt7.2.3.4-ga-20210226_1-1_amd64.deb
elif [ $cuda_major -eq 11 ] && [ $cuda_minor -eq 1 ]; then
    wget -q --show-progress --progress=bar:force:noscroll https://bit.ly/3Anko4s -O nv-tensorrt-repo-ubuntu1804-cuda11.1-trt7.2.3.4-ga-20210226_1-1_amd64.deb
    dpkg -i nv-tensorrt-repo-ubuntu1804-cuda11.1-trt7.2.3.4-ga-20210226_1-1_amd64.deb
    rm nv-tensorrt-repo-ubuntu1804-cuda11.1-trt7.2.3.4-ga-20210226_1-1_amd64.deb
fi
echo 'Done. Installing TensorRT packages...'

apt -y update
# see https://github.com/NVIDIA/TensorRT/issues/792#issuecomment-839636240 for sed command execution
sed -i -e '/nvidia/ s/^#*/#/' /etc/apt/sources.list.d/cuda.list
sed -i -e '/nvidia/ s/^#*/#/' /etc/apt/sources.list.d/nvidia-ml.list
apt -y install tensorrt python3-libnvinfer
rm -rf /var/lib/apt/lists/* 
rm -rf /var/nv-tensorrt-repo* /etc/apt/sources.list.d/nv-tensorrt-*
