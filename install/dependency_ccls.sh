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

# Installs ccls
#
# Parameters:
# - $1: install path
install_ccls() {
	echo ""
}

