#!/bin/bash

# fail immediately if we are in an interactive bash
case $- in
	*i*) ;;
	*) set -e;;
esac


# setup ros environment
source "/root/ros_catkin_ws/parent/install_isolated/setup.bash"
source "/root/ros_catkin_ws/common_pkgs_deps/install_isolated/setup.bash"
source "/root/ros_catkin_ws/common_pkgs/devel/setup.bash"
source "/root/ros_catkin_ws/dev/devel/setup.bash"

exec "$@"
