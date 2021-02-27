docker build -t ompugao/ros:melodic-desktop-full-cudnn8-gl -f Dockerfile.ros .
docker build -t ompugao/openrave-deps:melodic-desktop-full-cudnn8-gl -f Dockerfile.openrave-deps --target dev --build-arg from=ompugao/ros:melodic-desktop-full-cudnn8-gl . #
docker-compose --project-name openrave_extras_devenv -f /home/sifi/3rdparty/github.com/ompugao/openrave_extras_devenv/.devcontainer/docker-compose.yml build
