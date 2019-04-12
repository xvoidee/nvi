#!/bin/bash

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

nvimclipse_path=/opt/nvimclipse
thirdparty_path=/opt/nvimclipse_3rdparty

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

set_text_color() {
	tput setaf $1
}

print_info() {
	set_text_color 3
	echo $1
	set_text_color 0
}

print_success() {
	set_text_color 2
	echo $1
	set_text_color 0
}

print_fail() {
	set_text_color 1
	echo $1
	set_text_color 0
}

probe_command() {
	command -v $1 > /dev/null
}

probe_mkdir() {
	mkdir -p $1 > /dev/null
	if [[ $? -eq 1 ]] ; then
		print_fail "Unable to create folder $1"
		prereqs_met=false
	fi
}

install() {
	if [ ! -f temp/$2 ]; then
		wget -c $1/$2 -P temp/
	fi

	folder=`tar -tf temp/$2 --exclude '*/*'`
	tar -xf temp/$2 -C temp/
	mv temp/$folder $thirdparty_path/$3
}

prereqs_met=true

probe_mkdir $thirdparty_path
probe_mkdir $nvimclipse_path

if ( ! $prereqs_met ) ; then
	print_fail "Unable to create mandatory install directories, see above"
	exit 1
fi

probe_binary() {
	preinstalled_path=$1
	binary_name=$2
	relative_path=$3

	p="\$PATH"
	c=$binary_name

	if [ ! -z $preinstalled_path ] ; then
		p=$preinstalled_path/$relative_path
		c=$preinstalled_path/$relative_path/$binary_name
	fi

	probe_command $c
	if [[ $? = "1" ]] ; then
		print_fail "$binary_name not found in $p"
		prereqs_met=false
	fi
}

if ( $skip_nodejs_install ) ; then
	probe_binary \
		"$nodejs_path" \
		"node" \
		"bin"
	nodejs_path=""
else
	install \
		"https://nodejs.org/dist/v10.15.3" \
		"node-v10.15.3-linux-x64.tar.xz"
	nodejs_path="$thirdparty_path/node-v10.15.3-linux-x64"
fi

if ( $skip_clang_install ) ; then
	probe_binary \
		"$clang_path" \
		"clang" \
		"bin"
	clang_path=""
else
	install \
		"http://releases.llvm.org/7.0.1" \
		"clang+llvm-7.0.1-x86_64-linux-gnu-ubuntu-16.04.tar.xz"
	clang_path="$thirdparty_path/clang+llvm-7.0.1-x86_64-linux-gnu-ubuntu-16.04"
fi

if ( $skip_neovim_install ) ; then
	probe_binary \
		"$neovim_path" \
		"nvim" \
		"bin"
	neovim_path=""
else
	install \
		"https://github.com/neovim/neovim/releases/download/v0.3.4" \
		"nvim-linux64.tar.gz" \
		"nvim-0.3.4"
	neovim_path="$thirdparty_path/nvim-0.3.4"
fi

if ( $skip_ccls_install ) ; then
	probe_binary \
		"$ccls_path" \
		"ccls" \
		"bin"
	ccls_path=""
else

fi

if ( ! $prereqs_met ) ; then
	print_fail "Unmet prerequisites, check messages above"
fi

exit 0

