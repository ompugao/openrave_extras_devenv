# OpenRAVE + ROS melodic docker environment

![openrave on vscode remote container](https://i.gyazo.com/d856a7f339f7e77fd52a7bab6cda6983.png)
## Prerequiresites
- docker
- docker-compose
- buildkit
- nvidia-docker
- jinja2 (for generating Dockerfile)
- (vscode)

## Usage

```sh
# run only once
# activate buildkit for build cache
# (https://github.com/docker/buildx#setting-buildx-as-default-builder-in-docker-1903)
docker buildx install
cd path/to/openrave_docker_development_template
touch .devcontainer/.bash_history
git clone https://github.com/ompugao/openrave -b myworkingbranch
git clone https://github.com/ompugao/openrave_extras

# put whatever ros packages which depends only on openrave into common_pkgs
git clone https://github.com/personalrobotics/openrave_catkin common_pkgs/personalrobotics/openrave_catkin
#git clone https://github.com/personalrobotics/or_rviz catkin_ws/personalrobotics/or_rviz
git clone https://github.com/ompugao/or_rviz common_pkgs/ompugao/or_rviz -b feature/viewer_drawboxarray
git clone https://github.com/ompugao/openrave_extras_msgs common_pkgs/ompugao/openrave_extras_msgs
git clone https://github.com/crigroup/osr_course_pkgs common_pkgs/crigroup/osr_course_pkgs
git clone https://github.com/crigroup/robotiq common_pkgs/crigroup/robotiq -b melodic-devel
git clone https://github.com/quangounet/denso_common common_pkgs/quangounet/denso_common -b melodic-devel
git clone https://github.com/fsuarez6/bcap/  common_pkgs/fsuarez6/bcap
git clone https://github.com/ompugao/iai_kinect2.git common_pkgs/ompugao/iai_kinect2 -b mybranch
git clone https://github.com/UbiquityRobotics/fiducials UbiquityRobotics/fiducials

# when you build or run
bash ./set_xauth.sh
python3 gen_dockerfile.py .devcontainer/Dockerfile.openrave .devcontainer/Dockerfile.openrave.gen
# run vscode and open in Remote Dev Container, or
cd .devcontainer/ && bash build-deps.sh
```
