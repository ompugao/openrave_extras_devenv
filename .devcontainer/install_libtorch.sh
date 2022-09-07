#!/bin/bash
set -e

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

install_unzip() {
	apt update && apt install -y unzip
}
finalize() {
	apt remove -y unzip
	rm -rf /var/lib/apt/lists/*
}

semverParseInto $CUDA_VERSION cuda_major cuda_minor cuda_patch cuda_special
echo "$CUDA_VERSION -> M: $cuda_major m:$cuda_minor p:$cuda_patch s:$cuda_special"

mkdir -p ~/3rdparty && cd ~/3rdparty
# Install libtorch
if [ $cuda_major -eq 10 ] && [ $cuda_minor -eq 2 ]; then
	install_unzip
	wget -q --show-progress --progress=bar:force:noscroll https://download.pytorch.org/libtorch/cu102/libtorch-cxx11-abi-shared-with-deps-1.7.1.zip
	unzip libtorch-cxx11-abi-shared-with-deps-1.7.1.zip
	rm libtorch-cxx11-abi-shared-with-deps-1.7.1.zip
	finalize
elif [ $cuda_major -eq 11 ] && [ $cuda_minor -eq 0 ]; then
	install_unzip
	wget -q --show-progress --progress=bar:force:noscroll https://download.pytorch.org/libtorch/cu110/libtorch-cxx11-abi-shared-with-deps-1.7.1%2Bcu110.zip
	unzip libtorch-cxx11-abi-shared-with-deps-1.7.1+cu110.zip
	rm libtorch-cxx11-abi-shared-with-deps-1.7.1+cu110.zip
	finalize
elif [ $cuda_major -eq 11 ] && [ $cuda_minor -eq 1 ]; then
	install_unzip
	wget -q --show-progress --progress=bar:force:noscroll https://download.pytorch.org/libtorch/cu111/libtorch-cxx11-abi-shared-with-deps-1.8.1%2Bcu111.zip
	unzip libtorch-cxx11-abi-shared-with-deps-1.8.1+cu111.zip
	rm libtorch-cxx11-abi-shared-with-deps-1.8.1+cu111.zip
	finalize
# libtorch library files are truncated when ldconfig
# https://discuss.pytorch.org/t/libtorch-c-so-files-truncated-error-when-ldconfig/46404/2
# elif [ $cuda_major -eq 11 ] && [ $cuda_minor -eq 3 ]; then
# 	install_unzip
# 	wget -q --show-progress --progress=bar:force:noscroll https://download.pytorch.org/libtorch/cu113/libtorch-cxx11-abi-shared-with-deps-1.12.1%2Bcu113.zip
# 	unzip libtorch-cxx11-abi-shared-with-deps-1.12.1+cu113.zip
# 	rm libtorch-cxx11-abi-shared-with-deps-1.12.1+cu113.zip
# 	finalize
else
	# fatal: unable to access 'https://sourceware.org/git/valgrind.git/': server certificate verification failed. CAfile: /etc/ssl/certs/ca-certificates.crt CRLfile: none
	# fatal: clone of 'https://sourceware.org/git/valgrind.git' into submodule path '/root/3rdparty/pytorch/third_party/valgrind' failed
	# Failed to clone 'third_party/valgrind'. Retry scheduled
	export GIT_SSL_NO_VERIFY=1
	git clone --recursive -j $(nproc) --recurse-submodules https://github.com/pytorch/pytorch
	cd pytorch
	git checkout v1.12.1  # v1.11.0
	git submodule update --init --recursive
	cd ..
	#mkdir -p pytorch/build_libtorch && cd pytorch/build_libtorch
	#python ../tools/build_libtorch.py
	mkdir pytorch-build
	cd pytorch-build
	apt update && apt install -y python3.8 python3.8-venv python3.8-dev python3-pip
	# python3.8 -m ensurepip --upgrade  # not enabled for system python
	wget https://bootstrap.pypa.io/get-pip.py && python3.8 get-pip.py && rm get-pip.py
	python3.8 -m venv libtorchbuildenv
	source libtorchbuildenv/bin/activate
	python3.8 -m pip install --no-cache-dir Cython
	python3.8 -m pip install --no-cache-dir dataclasses PyYAML numpy typing-extensions future six requests dataclasses
	cmake -DBUILD_SHARED_LIBS:BOOL=ON -DCMAKE_BUILD_TYPE:STRING=Release -DPYTHON_EXECUTABLE:PATH=`which python3.8` -DCMAKE_INSTALL_PREFIX:PATH=../libtorch ../pytorch 
	cmake --build . --target install -- -j $(nproc)
	deactivate
	apt remove -y python3.8 python3.8-venv python3-pip
	# apt autoremove -y #this will try to remove sudo which causes the error pasted at the last
	rm -rf /var/lib/apt/lists/*
	cd ..
	rm -rf pytorch-build pytorch
fi
cp -r libtorch/* /usr/
rm libtorch -rf

# Removing sudo (1.8.21p2-3ubuntu1.4) ...                                              
# You have asked that the sudo package be removed,                                       
# but no root password has been set.                                                                               
# Without sudo, you may not be able to gain administrative privileges.                                  
#                                                                                                      
# If you would prefer to access the root account with su(1)                                                            
# or by logging in directly,                                                                           
# you must set a root password with "sudo passwd".                                                   
#                                                                                               
# If you have arranged other means to access the root account,     
# and you are sure this is what you want,                        
# you may bypass this check by setting an environment variable                                     
# (export SUDO_FORCE_REMOVE=yes).                                                        
#                                                                                                    
# Refusing to remove sudo.                                                                                       
# dpkg: error processing package sudo (--remove):                                                                
#  installed sudo package pre-removal script subprocess returned error exit status 1  
