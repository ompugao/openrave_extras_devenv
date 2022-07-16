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

CUDA_VERSION="${1:-11.1.1}"
semverParseInto $CUDA_VERSION cuda_major cuda_minor cuda_patch cuda_special
echo "$CUDA_VERSION -> M: $cuda_major m:$cuda_minor p:$cuda_patch s:$cuda_special"
if [ $cuda_major -eq 10 ] && [ $cuda_minor -eq 0 ]; then
	baseimage="nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04"
elif [ $cuda_major -eq 10 ] && [ $cuda_minor -eq 2 ]; then
	baseimage="nvidia/cuda:10.2-cudnn8-devel-ubuntu18.04"
elif [ $cuda_major -eq 11 ] && [ $cuda_minor -eq 0 ]; then
	baseimage="nvidia/cuda:11.0.3-cudnn8-devel-ubuntu18.04"
elif [ $cuda_major -eq 11 ] && [ $cuda_minor -eq 1 ]; then
	baseimage="nvidia/cuda:11.1.1-cudnn8-devel-ubuntu18.04"
elif [ $cuda_major -eq 11 ] && [ $cuda_minor -eq 3 ]; then
	baseimage="nvidia/cuda:11.3.1-cudnn8-devel-ubuntu18.04"
else
	echo "Unsupported CUDA Version: " $CUDA_VERSION
	exit 1
fi
echo "baseimage: " $baseimage


docker build -t ompugao/pytorch:cuda$cuda_major.$cuda_minor-cudnn8 -f Dockerfile.torch --build-arg from=$baseimage --build-arg cuda_major=$cuda_major --build-arg cuda_minor=$cuda_minor . 

