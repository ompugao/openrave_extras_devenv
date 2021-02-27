#!/bin/bash
set -e

# setup ros environment
source "/root/ros_catkin_ws/parent/install_isolated/setup.bash"
source "/root/ros_catkin_ws/common/devel/setup.bash"
source "/root/ros_catkin_ws/dev/devel/setup.bash"
exec "$@"
