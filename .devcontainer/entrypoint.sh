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

export OPENRAVE_PLUGINS=/usr/local/lib/openrave_extras_plugins/:$OPENRAVE_PLUGINS
osr_openrave_dir=$(rospack find osr_openrave 2>/dev/null)
if [ $? -eq 0 ]; then
    export OPENRAVE_DATA=$OPENRAVE_DATA:$(rospack find osr_openrave)
fi
export OPENRAVE_DATA=$OPENRAVE_DATA:/workspace/openrave_extras

exec "$@"
