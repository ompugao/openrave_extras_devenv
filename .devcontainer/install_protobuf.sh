#!/bin/bash
set -e
mkdir -p /root/3rdparty/
cd /root/3rdparty/
apt update
# gazebo depends on proto. we cannot use gazebo correctly anymore
apt remove -y libprotobuf-dev
apt-get -y install autoconf automake libtool curl make g++
wget https://github.com/protocolbuffers/protobuf/releases/download/v21.2/protobuf-all-21.2.tar.gz
tar axvf protobuf-all-21.2.tar.gz
cd protobuf-21.2
./autogen.sh
./configure --prefix=/usr
make -j $(nproc)
make install
cd ..
rm -rf protobuf-21.2 protobuf-all-21.2.tar.gz
