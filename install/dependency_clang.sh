#!/bin/bash

# Probes clang executable in:
# - $PATH
# - $clang_path if set
#
# Parameters:
# - $1: skip install
# - $2: preinstalled path
#
# Return:
# - 0 on success
# - 1 on failure
probe_clang() {
	if [ $1 == true ] ; then
		probe_binary "clang" "$2" "bin"
	fi
}

# Installs clang
#
# Parameters:
# - $1: install path
install_clang() {
	install "clang" $1 "http://releases.llvm.org/8.0.0" "clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-16.04.tar.xz"
}

