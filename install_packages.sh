#!/bin/bash

lsb_match=false
lsb_version="unknown"
probe_lsb_version "14.04" "lsb_match" "lsb_version"
probe_lsb_version "16.04" "lsb_match" "lsb_version"
probe_lsb_version "18.04" "lsb_match" "lsb_version"
if [ lsb_match == false ] ; then
	print_fail "Unknown Ubuntu version `lsb_release -r`"
	print_fail "Only 14.04/16.04/18.04 are supported"
	exit 1
fi

nodejs_website="https://nodejs.org/dist/v10.15.3"
nodejs_archive="node-v10.15.3-linux-x64.tar.xz"
nodejs_version="10.15.3"
nodejs_runtime="node-v10.15.3-linux-x64"

clang_website="http://releases.llvm.org/8.0.0"
clang_archive="clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-$lsb_version.tar.xz"
clang_version="8.0.0"
clang_runtime="clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-$lsb_version"

neovim_website="https://github.com/neovim/neovim/releases/download/stable"
neovim_archive="nvim-linux64.tar.gz"
neovim_version="0.3.5"
neovim_runtime="nvim-linux64"

cmake_website="https://github.com/Kitware/CMake/releases/download/v3.14.4"
cmake_archive="cmake-3.14.4-Linux-x86_64.tar.gz"
cmake_version="3.14.4-Linux-x86_64"

