#!/bin/bash

# Probes node executable in:
# - $PATH
# - $nodejs_path if set
#
# Parameters:
# - $1: skip install
# - $2: preinstalled path
#
# Return:
# - 0 on success
# - 1 on failure
probe_nodejs() {
	if [ $1 == true ] ; then
		probe_binary "node" "$2" "bin"
	fi
}

# Installs node
#
# Parameters:
# - $1: install path
install_nodejs() {
	install "node" $1 $nodejs_website $nodejs_archive
	nodejs_path=$install_path/nvimclipse_3rdparty/node-v10.15.3-linux-x64
}

