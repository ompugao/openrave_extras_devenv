set -e
python ../gen_dockerfile.py Dockerfile.openrave Dockerfile.openrave.gen --OPENRAVE_BUILD_TYPE=Release --ROS_BUILD_TYPE=Release
docker build -t ompugao/ros:melodic-desktop-full-cudnn8-gl -f Dockerfile.ros .
docker build -t ompugao/openrave-deps:melodic-desktop-full-cudnn8-gl -f Dockerfile.openrave-deps --target dev --build-arg from=ompugao/ros:melodic-desktop-full-cudnn8-gl . 
docker-compose --project-name openrave_extras_devenv -f ./docker-compose.yml build
