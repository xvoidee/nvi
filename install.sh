#!/bin/sh

print_help() {
	cat << EOF
Options:
 --help                     display help
 --no-alias                 do not create alias in ~/.bashrc
 --no-ccls                  do not install ccls
 --ccls-path=<path>         target directory where ccls will be installed
                            or directory with pre-installed ccls
                            default /opt/nvimclipse_3rdparty/
 --no-clang                 do not install clang
 --clang-path=<path>        target directory where clang will be installed
                            or directory with pre-installed clang
                            default /opt/nvimclipse_3rdparty/
 --no-neovim                do not install neovim
 --neovim-path=<path>       target directory where neovim will be installed
                            or directory with pre-installed neovim
                            default /opt/nvimclipse_3rdparty/
 --no-nodejs                do not install nodejs
 --nodejs-path=<path>       target directory where nodejs will be installed
                            default /opt/nvimclipse_3rdparty/
 --keep-cache               do not remove downloaded binaries
 --nvimclipse-path=<path>   target directory for nvimclipse home (configs, plugins)
                            default /opt/nvimclipse
 --3rdparty-path=<path>     target directory where 3rdparties are installed
                            default /opt/nvimclipse_3rdparty
EOF
}

opts=`/usr/bin/getopt \
	-o a,b,c,d:,e,f:,g,h:,j,k:,l:,m: \
	-l help,no-alias,no-ccls,ccls-path:,no-clang,clang-path:,no-neovim,neovim-path:,no-nodejs,nodejs-path:,keep-cache,nvimclipse-home:,3rdparty-home: \
	-- "$@" \
`

if [ $? != 0 ]; then
	echo "getopt failed"
	print_help
	exit 1
fi

no_ccls=false
ccls_path=$thirdparty_path

no_clang=false
clang_path=$thirdparty_path

no_neovim=false
neovim_path=$thirdparty_path

no_nodejs=false
nodejs_path=$thirdparty_path

no_alias=false
keep_cache=false

nvimclipse_path=/opt/nvimclipse
thirdparty_path=/opt/nvimclipse_3rdparty

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
		--nvimclipse-path )
			nvimclipse_path=$2
			shift
			shift
			;;
		--3rdparty-path)
			thirdparty_path=$2
			shift
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
	mv temp/$folder $thirdparty_path/$3
}

install_clang() {
	if ( $no_clang ); then
		return
	fi

	install \
		"http://releases.llvm.org/7.0.1" \
		"clang+llvm-7.0.1-x86_64-linux-gnu-ubuntu-16.04.tar.xz"

	clang_path="$thirdparty_path/clang+llvm-7.0.1-x86_64-linux-gnu-ubuntu-16.04"
}

install_neovim() {
	if ( $no_neovim ); then
		return
	fi

	install \
		"https://github.com/neovim/neovim/releases/download/v0.3.4" \
		"nvim-linux64.tar.gz" \
		"nvim-0.3.4"

	neovim_path="$thirdparty_path/nvim-0.3.4"
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
	mkdir $thirdparty_path/ccls
	mkdir $thirdparty_path/ccls/bin
	cp Release/ccls $thirdparty_path/ccls/bin
	cd ../..
	rm -rf temp/ccls
	rm -rf temp/$cmake_version

	ccls_path="$thirdparty_path/ccls"
}

install_nodejs() {
	if ( $no_nodejs ); then
		return
	fi

	install \
		"https://nodejs.org/dist/v10.15.3" \
		"node-v10.15.3-linux-x64.tar.xz"

	nodejs_path="$thirdparty_path/nodejs"
}

install_nvimclipse() {
	mkdir $nvimclipse_path/autoload
	cp vim-plug/plug.vim $nvimclipse_path/autoload/

	cp config/.cfg.*            $nvimclipse_path
	cp config/.vimrc*           $nvimclipse_path
	cp config/init.vim          $nvimclipse_path
	cp config/coc-settings.json $nvimclipse_path

	sed -i "s|%clang_path%|$clang_path|g"           $nvimclipse_path/.cfg.chromatica
	sed -i "s|%clang_version%|7.0.1|g"              $nvimclipse_path/.cfg.chromatica
	sed -i "s|%nvimclipse_path%|$nvimclipse_path|g" $nvimclipse_path/.vimrc
	sed -i "s|%nvimclipse_path%|$nvimclipse_path|g" $nvimclipse_path/.vimrc.plugins
	sed -i "s|%nvimclipse_path%|$nvimclipse_path|g" $nvimclipse_path/init.vim
	sed -i "s|%ccls_path%|$ccls_path|g"             $nvimclipse_path/coc-settings.json

	mkdir ~/.config/nvim
	ln -s $nvimclipse_path/coc-settings.json ~/.config/nvim/coc-settings.json

	PATH=$PATH:$nodejs_path/bin $neovim_path/bin/nvim -u ./install.vim \
	    +PlugInstall \
	    +UpdateRemotePlugins \
	    +":call coc#util#install()" \
	    +qa
}

install_alias() {
	echo "\nalias nv='PATH=$PATH:$nodejs_path/bin $neovim_path/bin/nvim -u $nvimclipse_path/init.vim'\n" >> ~/.bashrc
}

#mkdir temp
#mkdir $thirdparty_path
mkdir $nvimclipse_path

clang_path="$thirdparty_path/clang+llvm-7.0.1-x86_64-linux-gnu-ubuntu-16.04"
neovim_path="$thirdparty_path/nvim-0.3.4"
ccls_path="$thirdparty_path/ccls"
nodejs_path="$thirdparty_path/node-v10.15.3-linux-x64"

#install_clang
#install_ccls
#install_neovim
#install_nodejs
install_nvimclipse
install_alias
