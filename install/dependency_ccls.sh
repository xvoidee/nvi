#!/bin/bash

# Probes ccls executable in:
# - $PATH
# - $ccls_path if set
#
# Parameters:
# - $1: skip install
# - $2: preinstalled path
#
# Return:
# - 0 on success
# - 1 on failure
probe_ccls() {
	if [ $1 == true ] ; then
		probe_binary "ccls" "$2" "bin"
	fi
}

#../cmake-3.14.2-Linux-x86_64/bin/cmake -H. -BRelease -DCMAKE_CXX_COMPILER=g++-8 -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=/opt/nvimclipse_3rdparty/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-16.04
#../cmake-3.14.2-Linux-x86_64/bin/cmake --build Release

# Installs ccls
#
# Parameters:
# - $1: install path
install_ccls() {
	cmake_command="`pwd`/temp/cmake-$cmake_version/bin/cmake"
	cmake_archive="cmake-$cmake_version.tar.gz"

	if [ ! -f temp/$cmake_archive ]; then
		wget -c $cmake_website/$cmake_archive -P temp
	fi
	tar -xf temp/$cmake_archive -C temp/

	cd temp
	git clone --depth=1 --recursive https://github.com/MaskRay/ccls
	cd ccls

	gcc="g++-8"
	if [ $missing_gcc8 == true ] ; then
		gcc="g++-7"
	fi
	echo $cmake_command
	eval $cmake_command -H. -BRelease \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_PREFIX_PATH=$clang_path \
		-DCMAKE_CXX_COMPILER=$gcc
	eval $cmake_command --build Release -j4
	mkdir $install_path/nvimclipse_3rdparty/ccls
	mkdir $install_path/nvimclipse_3rdparty/ccls/bin
	cp Release/ccls $install_path/nvimclipse_3rdparty/ccls/bin
	cd ../..
	rm -rf temp/ccls
	rm -rf temp/$cmake_version
	ccls_path=$install_path/nvimclipse_3rdparty/ccls
}

