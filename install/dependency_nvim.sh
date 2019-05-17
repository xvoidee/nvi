#!/bin/bash

# Probes nvim executable in:
# - $PATH
# - $nvim_path if set
#
# Parameters:
# - $1: skip install
# - $2: preinstalled path
#
# Return:
# - 0 on success
# - 1 on failure
probe_nvim() {
	if [ $1 == true ] ; then
		probe_binary "nvim" "$2" "bin"
	fi
}

# Installs neovim
#
# Parameters:
# - $1: install path
install_nvim() {
	install "nvim" $1 $nvim_website $nvim_archive "nvim-$nvim_version"
	nvim_path=$install_path/nvimclipse_3rdparty/nvim-0.3.5
}

