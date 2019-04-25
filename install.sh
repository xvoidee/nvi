#!/bin/bash

rm -rf /opt/bla/*

source install/helpers.sh
source install/dependency_clang.sh
source install/dependency_nodejs.sh
source install/dependency_nvim.sh

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

install_path="/opt"

nodejs_skip=false
nodejs_path=""

clang_skip=false
clang_path=""

nvim_skip=false
nvim_path=""

#skip_ccls_install=false
#ccls_path=""

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
			skip_ccls_install=true
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
probe_nodejs $nodejs_skip "$nodejs_path"
probe_clang  $clang_skip  "$clang_path"
probe_nvim   $nvim_skip   "$nvim_path"
if [ $errno -eq 1 ] ; then
	print_fail "at least one of prereqs is unmet, setup will exit"
	exit 1
fi

errno=0
probe_mkdir "$install_path/nvimclipse"
probe_mkdir "$install_path/nvimclipse_3rdparty"
if [ $errno -eq 1 ] ; then
	print_fail "at least one required directory was not created, setup will exit"
	exit 1
fi

errno=0
install_nvim   "$install_path/nvimclipse_3rdparty"
install_nodejs "$install_path/nvimclipse_3rdparty"
install_clang  "$install_path/nvimclipse_3rdparty"
exit 0

#probe_mkdir $thirdparty_path
#probe_mkdir $nvimclipse_path
#mkdir -p "temp"

#probe_or_install $skip_nodejs_install \
#	"$nodejs_path" "node" "bin" \
#	"$thirdparty_path" "https://nodejs.org/dist/v10.15.3" "$archive_nodejs"

probe_or_install $skip_clang_install \
	"$clang_path" "clang" "bin" \
	$thirdparty_path "http://releases.llvm.org/8.0.0" $archive_clang
$clang_path=$?

#probe_or_install $skip_neovim_install \
#	"$neovim_path" "nvim" "bin" \
#	$thirdparty_path "https://github.com/neovim/neovim/releases/download/v0.3.4" $archive_neovim "nvim-0.3.4"

probe_or_install_ccls $skip_ccls_install \
	"$ccls_path" "ccls" "bin" \
	"$clang_path" "$thirdparty_path"

