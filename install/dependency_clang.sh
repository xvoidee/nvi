#!/bin/bash

# Probes clang executable in:
# - $PATH
# - $clang_path if set
#
# Parameters:
# - $1: preinstalled path
#
# Return:
# - 0 on success
# - 1 on failure
probe_clang() {
	probe_binary "clang" "$1" "bin"
}

