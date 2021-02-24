# OpenRAVE + ROS melodic docker environment

![openrave on vscode remote container](https://i.gyazo.com/d856a7f339f7e77fd52a7bab6cda6983.png)
## Prerequiresites
- docker
- docker-compose
- buildkit
- nvidia-docker
- (vscode)

## Usage

```sh
# run only once
# activate buildkit for build cache
# (https://github.com/docker/buildx#setting-buildx-as-default-builder-in-docker-1903)
docker buildx install
cd path/to/openrave_docker_development_template
bash ./set_xauth.sh
touch .devcontainer/.bash_history
git clone https://github.com/rdiankov/openrave
# put whatever ros packages you want into catkin_ws directory
git clone https://github.com/personalrobotics/openrave_catkin catkin_ws/personalrobotics/openrave_catkin
git clone https://github.com/personalrobotics/or_rviz catkin_ws/personalrobotics/or_rviz
# run vscode, or
cd .devcontainer/ && docker-compose up


```
