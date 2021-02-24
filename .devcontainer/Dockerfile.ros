#FROM osrf/ros:melodic-desktop-full
FROM nvidia/cuda:11.0.3-cudnn8-devel-ubuntu18.04

MAINTAINER Shohei Fujii <fujii.shohei@gmail.com>

# -------
# libglvnd support

# taken from
# https://gitlab.com/nvidia/container-images/opengl/blob/ubuntu18.04/glvnd/devel/Dockerfile
RUN apt-get update && apt-get install -y --no-install-recommends \
        pkg-config \
        libglvnd-dev  \
        libgl1-mesa-dev \
        libegl1-mesa-dev \
        libgles2-mesa-dev && \
    rm -rf /var/lib/apt/lists/*

# -------

ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
# install packages
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -q -y --no-install-recommends \
    dirmngr \
    gnupg2 \
    tzdata \
    && rm -rf /var/lib/apt/lists/*

# setup keys
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

# setup sources.list
RUN echo "deb http://packages.ros.org/ros/ubuntu bionic main" > /etc/apt/sources.list.d/ros1-latest.list

# setup environment
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# install bootstrap tools
RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    python-pip \
    # python-rosdep \
    # python-rosinstall \
    # python-vcstools \
    # python-rosinstall-generator \
    && rm -rf /var/lib/apt/lists/*
RUN pip install -U setuptools pip
RUN pip install -U rosdep rosinstall_generator vcstool rosinstall

ENV ROS_DISTRO melodic

# bootstrap rosdep
RUN rosdep init && \
  rosdep update --rosdistro $ROS_DISTRO

RUN mkdir -p ~/ros_catkin_ws/parent && cd ~/ros_catkin_ws/parent && mkdir src \
	&& rosinstall_generator desktop_full --rosdistro $ROS_DISTRO --deps --tar > $ROS_DISTRO-desktop-full.rosinstall \
	&& apt-get update && vcs import src < $ROS_DISTRO-desktop-full.rosinstall \
	&& rosdep install --from-paths src --ignore-src --rosdistro $ROS_DISTRO -y \
	&& rm -rf /var/lib/apt/lists/*

# Install boost 1.58 from source
RUN apt-get update && apt-get install -y --no-install-recommends wget \
    && rm -rf /var/lib/apt/lists/*
RUN BOOST_SRC_DIR=~/3rdparty/boost_1_58_0 \
    && mkdir -p ~/3rdparty; cd ~/3rdparty \
    && wget http://sourceforge.net/projects/boost/files/boost/1.58.0/boost_1_58_0.tar.gz -O ${BOOST_SRC_DIR}.tar.gz \
    && tar -xzf ${BOOST_SRC_DIR}.tar.gz \
    && cd ${BOOST_SRC_DIR} \
    && ./bootstrap.sh --exec-prefix=/usr/local \
    && ./b2 -j `nproc` \
    && ./b2 -j `nproc` install threading=multi \
	&& cd .. && rm -rf ${BOOST_SRC_DIR} ${BOOST_SRC_DIR}.tar.gz

RUN cd ~/ros_catkin_ws/parent \
	&& BOOST_ROOT=/usr/local ./src/catkin/bin/catkin_make_isolated --install -DCMAKE_BUILD_TYPE=Release -DBoost_NO_BOOST_CMAKE=ON \
	&& rm -rf ./build_isolated

ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

# setup entrypoint
# COPY ./ros_entrypoint.sh /
# ENTRYPOINT ["/ros_entrypoint.sh"]
# CMD ["bash"]
