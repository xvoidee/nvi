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
	install "nvim" $1 "https://github.com/neovim/neovim/releases/download/v0.3.4" "nvim-linux64.tar.gz" "nvim-0.3.4"
}

