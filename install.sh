#!/bin/bash

source install/helpers.sh
source install/packages.sh
source install/dependency_ccls.sh
source install/dependency_clang.sh
source install/dependency_nodejs.sh
source install/dependency_nvim.sh
source install/install_nvimclipse.sh

print_help() {
	cat << EOF
Options:
 --help                     display help
 --install-path=<path>      target directory for nvimclipse
                            default /opt
                            script will create 2 sub folders: nvimclipse, nvimclipse_3rdparty
 --skip-nodejs-install      do not download nodejs, use system-provided instead
 --nodejs-path=<path>       path to system-provided nodejs
                            leave unset to autodetect from \$PATH
 --skip-clang-install       do not download clang, use system-provided instead
 --clang-path=<path>        path to system-provided clang
                            leave unset to autodetect from \$PATH
 --skip-neovim-install      do not download neovim, use system-provided instead
 --neovim-path=<path>       path to system-provided neovim
                            leave unset to autodetect from \$PATH
 --skip-ccls-install        do not download and build ccls, use system-provided instead
 --ccls-path=<path>         path to system-provided ccls
                            leave unset to autodetect from \$PATH
EOF
}

opts=`/usr/bin/getopt -o '' --long help,install-path:,skip-nodejs-install,nodejs-path:,skip-clang-install,clang-path:,skip-neovim-install,neovim-path:,skip-ccls-install,-ccls-path: -- "$@"`

if [ $? != 0 ] ; then
	echo "getopt failed"
	print_help
	exit 1
fi

install_path="/opt/bla"

nodejs_skip=false
nodejs_path=""

clang_skip=false
clang_path=""

nvim_skip=false
nvim_path=""

ccls_skip=false
ccls_path=""

eval set -- "$opts"
while true ; do
	case "$1" in
		--help)
			print_help
			exit 0
			;;
		--install-path)
			install_path=$2
			shift
			shift
			;;
		--skip-nodejs-install)
			nodejs_skip=true
			shift
			;;
		--nodejs-path)
			nodejs_path=$2
			shift
			shift
			;;
		--skip-clang-install)
			clang_skip=true
			shift
			;;
		--clang-path)
			clang_path=$2
			shift
			shift
			;;
		--skip-neovim-install)
			nvim_skip=true
			shift
			;;
		--neovim-path)
			nvim_path=$2
			shift
			shift
			;;
		--skip-ccls-install)
			ccls_skip=true
			shift
			;;
		--ccls-path)
			ccls_path=$2
			shift
			shift
			;;
		--)
			shift
			break
			;;
		*)
			echo "unknown error"
			exit 1
			;;
	esac
done

errno=0
missing_packages=false
probe_package "python3"
probe_binary "python3"
probe_package "python3-pip"
probe_binary "pip3"
probe_pip3_package "neovim"
if [ $errno -eq 1 ] ; then
	missing_packages=true
fi

errno=0
missing_gcc7=false
print_info "checking for g++-7"
probe_binary "g++-7"
if [ $errno -eq 1 ] ; then
	missing_gcc7=true
fi

errno=0
missing_gcc8=false
print_info "checking for g++-8"
probe_binary "g++-8"
if [ $errno -eq 1 ] ; then
	missing_gcc8=true
fi

if [[ $missing_packages == true || ( $missing_gcc7 == true && $missing_gcc8 == true ) ]] ; then
	print_fail "at least on required dependency was not met, setup will exit"
	exit 1
fi

errno=0
if [ -d $install_path/nvimclipse ] ; then
	print_fail "directory $install_path/nvimclipse exists"
	errno=1
fi
if [ -d $install_path/nvimclipse_3rdparty ] ; then
	print_fail "directory $install_path/nvimclipse_3rdparty exists"
	errno=1
fi
if [ $errno -eq 1 ] ; then
	print_fail "one of the install directories (previous install?) exists, setup will exit"
	exit 0
fi

errno=0
probe_mkdir "$install_path/nvimclipse"
probe_mkdir "$install_path/nvimclipse_3rdparty"
if [ $errno -eq 1 ] ; then
	print_fail "at least one required directory was not created, setup will exit"
	rm -rf $install_path/nvimclipse
	rm -rf $install_path/nvimclipse_3rdparty
	exit 1
fi

probe_nodejs $nodejs_skip "$nodejs_path"
probe_clang  $clang_skip  "$clang_path"
probe_nvim   $nvim_skip   "$nvim_path"
probe_ccls   $ccls_skip   "$ccls_path"
if [ $errno -eq 1 ] ; then
	print_fail "at least one of prereqs is unmet, setup will exit"
	exit 1
fi

errno=0
install_nvim   "$install_path/nvimclipse_3rdparty"
install_nodejs "$install_path/nvimclipse_3rdparty"
install_clang  "$install_path/nvimclipse_3rdparty"
install_ccls   "$install_path/nvimclipse_3rdparty"
install_nvimclipse

