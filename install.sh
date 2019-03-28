#!/bin/sh

print_help() {
	cat << EOF
Options:
 --help                display help
 --no-alias            do not create alias in ~/.bashrc
 --no-ccls             do not install ccls
 --ccls-path=<path>    target directory where ccls will be installed
                       or directory with pre-installed ccls
                       default /opt/nvimclipse_3rdparty/
 --no-clang            do not install clang
 --clang-path=<path>   target directory where clang will be installed
                       or directory with pre-installed clang
                       default /opt/nvimclipse_3rdparty/
 --no-neovim           do not install neovim
 --neovim-path=<path>  target directory where neovim will be installed
                       or directory with pre-installed neovim
                       default /opt/nvimclipse_3rdparty/
 --no-nodejs           do not install nodejs
 --nodejs-path=<path>  target directory where nodejs will be installed
                       default /opt/nvimclipse_3rdparty/
 --keep-cache          do not remove downloaded binaries
EOF
}

opts=`/usr/bin/getopt \
	-o a,b,c,d:,e,f:,g,h:,j,k:,l \
	-l help,no-alias,no-ccls,ccls-path:,no-clang,clang-path:,no-neovim,neovim-path:,no-nodejs,nodejs-path:,keep-cache \
	-- "$@" \
`

if [ $? != 0 ]; then
	echo "getopt failed"
	print_help
	exit 1
fi

default_3rdparty_prefix=/opt/nvimclipse_3rdparty

no_alias=false

no_ccls=false
ccls_path=$default_3rdparty_prefix

no_clang=false
clang_path=$default_3rdparty_prefix

no_neovim=false
neovim_path=$default_3rdparty_prefix

no_nodejs=false
nodejs_path=$default_3rdparty_prefix

keep_cache=false

eval set -- "$opts"
while true; do
  case "$1" in
		--help )
			print_help
			shift
      ;;
		--no-alias )
			no_alias=true
			shift
			;;
		--no-ccls )
			no_ccls=true
			shift
			;;
		--ccls-path )
			ccls_path=$2
			shift
			shift
			;;
		--no-clang )
			no_clang=true
			shift
			;;
		--clang-path )
			clang_path=$2
			shift
			shift
			;;
		--no-neovim )
			no_neovim=true
			shift
			;;
		--neovim-path )
			neovim_path=$2
			shift
			shift
			;;
		--no-nodejs )
			no_nodejs=true
			shift
			;;
		--nodejs-path )
			nodejs_path=$2
			shift
			shift
			;;
		--keep-cache )
			keep_cache=true
			shift
			;;
		-- )
			shift
			break
			;;
		* )
			echo "Unknown option $1"
			print_help
			exit 1
			;;
  esac
done

install() {
	if [ ! -f temp/$2 ]; then
		wget -c $1/$2 -P temp/
	fi

	folder=`tar -tf temp/$2 --exclude '*/*'`
	tar -xf temp/$2 -C temp/
	mv temp/$folder $default_3rdparty_prefix/$3
}

install_clang() {
	if ( $no_clang ); then
		return
	fi

	install \
		"http://releases.llvm.org/7.0.1" \
		"clang+llvm-7.0.1-x86_64-linux-gnu-ubuntu-16.04.tar.xz"

	clang_path="$default_3rdparty_prefix/clang+llvm-7.0.1-x86_64-linux-gnu-ubuntu-16.04"
}

install_neovim() {
	if ( $no_neovim ); then
		return
	fi

	install \
		"https://github.com/neovim/neovim/releases/download/v0.3.4" \
		"nvim-linux64.tar.gz" \
		"nvim-0.3.4"
}

install_ccls() {
	if ( $no_ccls ); then
		return
	fi

	cmake_version="cmake-3.14.0-Linux-x86_64"
	cmake_command="`pwd`/temp/$cmake_version/bin/cmake"
	cmake_archive="$cmake_version.tar.gz"
	if [ ! -f temp/$cmake_archive ]; then
		wget -c "https://github.com/Kitware/CMake/releases/download/v3.14.0/$cmake_archive" -P temp
	fi
	tar -xf temp/$cmake_archive -C temp/

	cd temp
	git clone --depth=1 --recursive https://github.com/MaskRay/ccls
	cd ccls

	eval $cmake_command -H. -BRelease \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_PREFIX_PATH=$clang_path \
		-DCMAKE_CXX_COMPILER=$clang_path/bin/clang++
	eval $cmake_command --build Release
	mkdir $default_3rdparty_prefix/ccls
	mkdir $default_3rdparty_prefix/ccls/bin
	cp Release/ccls $default_3rdparty_prefix/ccls/bin
	cd ../..
	rm -rf temp/ccls
	rm -rf temp/$cmake_version
}

install_nodejs() {
	if ( $no_nodejs ); then
		return
	fi

	install \
		"https://nodejs.org/dist/v10.15.3" \
		"node-v10.15.3-linux-x64.tar.xz"
}

create_alias() {
	echo "\nalias nv='nvim -u ~/.nvimclipse/init.vim'\n" >> ~/.bashrc
}

mkdir temp
mkdir /opt/nvimclipse_3rdparty
mkdir /opt/nvimclipse

install_clang
install_ccls
install_neovim
install_nodejs

