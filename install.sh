#!/bin/bash

# $1 - text
# $2 - color
print() {
	tput setaf $2
	echo "$1"
	tput init
}

print_info() {
	print "$1" 3
}

print_success() {
	print "$1" 2
}

print_fail() {
	print "$1" 1
}

# $1 - binary name
# $2 - status variable name
probe_executable() {
	command -v $1 > /dev/null
	if [ $? -eq 1 ] ; then
		print_fail "  $1"
		eval "$2=true"
		return 1
	fi
	print_success "  $1"
	return 0
}

# $1 - pip3 package name
# $2 - status variable name
# $3 - human friendly name
probe_pip3_package() {
	pip3 list | grep $1 > /dev/null
	if [ $? -eq 1 ] ; then
		print_fail "  $3"
		eval "$2=true"
		return 1
	fi
	print_success "  $3"
	return 0
}

# $1 - path
# $2 - status variable if failed
probe_mkdir() {
	if [ -d $1 ] ; then
		print_fail "  $1 exists"
		eval "$2=true"
		return 1
	else
		mkdir -p $1
		if [ $? -eq 1 ] ; then
			print_fail "  $1 was not created"
			eval "$2=true"
			return 1
		fi

		print_success "  $1"
		return 0
	fi
}

# $1 - website
# $2 - archive to download
# $3 - status variable name if download failed
download() {
	mkdir -p temp
	print_info "  $2"
	wget -c $1/$2 -P temp/

	if [ ! -f temp/$2 ] ; then
		print_fail "  $2 was not downloaded"
		eval "$2=true"
		return 1
	fi

	print_success "  $2"
	return 0
}

# $1 - archive
# $2 - target directory
extract() {
	print_info "  $1"
	tar -xf temp/$1 -C $2/
	print_success "  $1"
}

print_help() {
	cat << EOF
Options:
 --help                     display help
 --install-path=<path>      target directory for installation (only absolute pathes accepted)
                            default is /opt
                            script will create 2 sub folders: nvimclipse, nvimclipse_3rdparty
EOF
}

opts=`/usr/bin/getopt -o '' --long help,install-path: -- "$@"`

if [ $? != 0 ] ; then
	echo "getopt failed"
	print_help
	exit 1
fi

install_path="/opt"

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

missing_packages=false
missing_gnu_cpp7=false
missing_gnu_cpp8=false

print_info "Checking for dependencies:"
probe_executable "python3" "missing_packages"
probe_executable "pip3"    "missing_packages"
probe_executable "g++-7"   "missing_gnu_cpp7"
probe_executable "g++-8"   "missing_gnu_cpp8"

if [[ $missing_packages == true || ( $missing_gnu_cpp7 == true && $missing_gnu_cpp8 == true ) ]] ; then
	print_fail "Dependencies check failed, setup will exit"
	exit 1
fi

missing_packages=false
probe_pip3_package "neovim" "missing_packages" "pip3 neovim"
if [ $missing_packages == true ] ; then
	print_fail "Dependencies check failed, setup will exit"
	exit 1
fi

print_info "Creating for installation folders"

mkdir_failed=false
probe_mkdir "$install_path/nvimclipse"          "mkdir_failed"
probe_mkdir "$install_path/nvimclipse_3rdparty" "mkdir_failed"
if [ $mkdir_failed == true ] ; then
	print_fail "Folders check failed, setup will exit"
	exit 1
fi

if [[ (-L ~/.config/nvim/coc-settings.json) || (-f ~/.config/nvim/coc-settings.json) ]] ; then
	print_fail "~/.config/nvim/coc-settings.json exists, setup will exit"
	exit 1
fi

nodejs_website="https://nodejs.org/dist/v10.15.3"
nodejs_archive="node-v10.15.3-linux-x64.tar.xz"
nodejs_version="10.15.3"
nodejs_path="$install_path/nvimclipse_3rdparty/node-v10.15.3-linux-x64"

clang_website="http://releases.llvm.org/7.0.1/"
clang_archive="clang+llvm-7.0.1-x86_64-linux-gnu-ubuntu-18.04.tar.xz"
clang_version="7.0.1"
clang_path="$install_path/nvimclipse_3rdparty/clang+llvm-7.0.1-x86_64-linux-gnu-ubuntu-18.04"

neovim_website="https://github.com/neovim/neovim/releases/download/stable"
neovim_archive="nvim-linux64.tar.gz"
neovim_version="0.3.5"
neovim_path="$install_path/nvimclipse_3rdparty/nvim-linux64"

cmake_website="https://github.com/Kitware/CMake/releases/download/v3.14.4"
cmake_archive="cmake-3.14.4-Linux-x86_64.tar.gz"
cmake_version="3.14.4-Linux-x86_64"

print_info "Downloading dependencies"
print_info "  $nodejs_archive"
print_info "  $neovim_archive"
print_info "  $clang_archive"
print_info "  $cmake_archive"

download_failed=false
download $nodejs_website $nodejs_archive "download_failed"
download $neovim_website $neovim_archive "download_failed"
download $clang_website  $clang_archive  "download_failed"
download $cmake_website  $cmake_archive  "download_failed"
if [ $download_failed == true ] ; then
	print_fail "Download failed, setup will exit"
	exit 1
fi

print_info "Extracting dependencies"
extract $nodejs_archive "$install_path/nvimclipse_3rdparty"
extract $neovim_archive "$install_path/nvimclipse_3rdparty"
extract $clang_archive  "$install_path/nvimclipse_3rdparty"
extract $cmake_archive "temp"

print_info "Building ccls C++ language server"

cmake_command="`pwd`/temp/cmake-$cmake_version/bin/cmake"
cd temp
if [ ! -d ccls ] ; then
	git clone --depth=1 --recursive https://github.com/MaskRay/ccls
fi
cd ccls
gcc="g++-8"
if [ $missing_gnu_cpp8 == true ] ; then
	gcc="g++-7"
fi
eval "$cmake_command -H. -BRelease \
	-DCMAKE_BUILD_TYPE=Release \
	-DCMAKE_PREFIX_PATH=$install_path/nvimclipse_3rdparty/clang+llvm-7.0.1-x86_64-linux-gnu-ubuntu-18.04 \
	-DCMAKE_CXX_COMPILER=$gcc"
eval $cmake_command --build Release -j4
if [ ! -f Release/ccls ] ; then
	print_fail "Build failed, setup will exit"
	exit 1
fi
mkdir -p $install_path/nvimclipse_3rdparty/ccls
mkdir -p $install_path/nvimclipse_3rdparty/ccls/bin
cp Release/ccls $install_path/nvimclipse_3rdparty/ccls/bin
cd ../..
rm -rf temp/ccls
ccls_path=$install_path/nvimclipse_3rdparty/ccls

git submodule init
git submodule update
mkdir $install_path/nvimclipse/autoload
cp vim-plug/plug.vim $install_path/nvimclipse/autoload/

cp config/.cfg.*            $install_path/nvimclipse
cp config/.vimrc*           $install_path/nvimclipse
cp config/init.vim          $install_path/nvimclipse
cp config/coc-settings.json $install_path/nvimclipse

cp install.vim $install_path/nvimclipse

sed -i "s|%clang_path%|$clang_path|g"                   $install_path/nvimclipse/.cfg.chromatica
sed -i "s|%clang_version%|$clang_version|g"             $install_path/nvimclipse/.cfg.chromatica
sed -i "s|%nvimclipse_path%|$install_path/nvimclipse|g" $install_path/nvimclipse/.vimrc
sed -i "s|%nvimclipse_path%|$install_path/nvimclipse|g" $install_path/nvimclipse/.vimrc.plugins
sed -i "s|%nvimclipse_path%|$install_path/nvimclipse|g" $install_path/nvimclipse/init.vim
sed -i "s|%ccls_path%|$ccls_path/bin/ccls|g"            $install_path/nvimclipse/coc-settings.json
sed -i "s|%nvimclipse_path%|$install_path/nvimclipse|g" $install_path/nvimclipse/install.vim

echo "" >> ~/.bashrc
echo "alias nv='PATH=$PATH:$nodejs_path/bin $neovim_path/bin/nvim -u $install_path/nvimclipse/init.vim'" >> ~/.bashrc
echo "" >> ~/.bashrc

mkdir -p ~/.config/nvim
ln -sf $install_path/nvimclipse/coc-settings.json ~/.config/nvim/coc-settings.json

	PATH=$PATH:$nodejs_path/bin $neovim_path/bin/nvim -u $install_path/nvimclipse/install.vim \
		+PlugInstall \
		+UpdateRemotePlugins \
		+":call coc#util#install()" \
		+qa
rm $install_path/nvimclipse/install.vim

