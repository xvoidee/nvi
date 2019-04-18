#!/bin/bash

#source install/helpers.sh
#source probe/probe_nodejs.sh

#source install/ubuntu_16.sh
#source install/install_ccls.sh
#source install/install_nvimclipse.sh

print_help() {
	cat << EOF
Options:
 --help                     display help
 --nvimclipse-path=<path>   target directory for nvimclipse home (configs, plugins)
                            default /opt/nvimclipse
 --3rdparty-path=<path>     target directory for 3rdparties
                            default /opt/nvimclipse_3rdparty
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

opts=`/usr/bin/getopt -o '' --long help,nvimclipse-path:,3rdparty-path:,skip-nodejs-install,nodejs-path:,skip-clang-install,clang-path:,skip-neovim-install,neovim-path:,skip-ccls-install,-ccls-path: -- "$@"`

if [ $? != 0 ] ; then
	echo "getopt failed"
	print_help
	exit 1
fi

declare -A config
config[nvimclipse_path]=/opt/nvimclipse
config[thirdparty_path]=/opt/nvimclipse_3rdparty

declare -A config_nodejs
config_nodejs[skip]=false
config_nodejs[path]=""

skip_nodejs_install=false
nodejs_path=""

skip_clang_install=false
clang_path=""

skip_neovim_install=false
neovim_path=""

skip_ccls_install=false
ccls_path=""

eval set -- "$opts"
while true ; do
	case "$1" in
		--help)
			print_help
			exit 0
			;;
		--nvimclipse-path)
			nvimclipse_path=$2
			shift
			shift
			;;
		--3rdparty-path)
			thirdparty_path=$2
			shift
			shift
			;;
		--skip-nodejs-install)
			skip_nodejs_install=true
			shift
			;;
		--nodejs-path)
			nodejs_path=$2
			shift
			shift
			;;
		--skip-clang-install)
			skip_clang_install=true
			shift
			;;
		--clang-path)
			clang_path=$2
			shift
			shift
			;;
		--skip-neovim-install)
			skip_neovim_install=true
			shift
			;;
		--neovim-path)
			neovim_path=$2
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

probe_nodejs
install_nodejs

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

