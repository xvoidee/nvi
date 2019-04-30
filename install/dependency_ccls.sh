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

../cmake-3.14.2-Linux-x86_64/bin/cmake -H. -BRelease -DCMAKE_CXX_COMPILER=g++-8 -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=/opt/nvimclipse_3rdparty/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-16.04
../cmake-3.14.2-Linux-x86_64/bin/cmake --build Release

# Installs ccls
#
# Parameters:
# - $1: install path
install_ccls() {
	echo ""
}

