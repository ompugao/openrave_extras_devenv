set -e
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1
python3 ../gen_dockerfile.py Dockerfile.openrave Dockerfile.openrave.gen --OPENRAVE_BUILD_TYPE=Release --ROS_BUILD_TYPE=Release

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
if [ $cuda_major -eq 10 ] && [ $cuda_minor -eq 2 ]; then
	baseimage="nvidia/cuda:10.2-cudnn8-devel-ubuntu18.04"
elif [ $cuda_major -eq 11 ] && [ $cuda_minor -eq 0 ]; then
	baseimage="nvidia/cuda:11.0.3-cudnn8-devel-ubuntu18.04"
elif [ $cuda_major -eq 11 ] && [ $cuda_minor -eq 1 ]; then
	baseimage="nvidia/cuda:11.1.1-cudnn8-devel-ubuntu18.04"
else
	echo "Unsupported CUDA Version: " $CUDA_VERSION
	exit 1
fi
echo "baseimage: " $baseimage

docker build -t ompugao/ros:melodic-desktop-full-cudnn8-gl -f Dockerfile.ros --build-arg from=$baseimage --progress=plain .
docker build -t ompugao/openrave-deps:melodic-desktop-full-cudnn8-gl -f Dockerfile.openrave-deps --target dev --build-arg from=ompugao/ros:melodic-desktop-full-cudnn8-gl . 
docker-compose --project-name openrave_extras_devenv -f ./docker-compose.yml build
