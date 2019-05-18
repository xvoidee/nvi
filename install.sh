#!/bin/bash

source install_helpers.sh
source install_packages.sh

print_help() {
	cat << EOF
Options:
 --help                   display help
 --install-path=<path>    target directory for installation, default is /opt
                          script will create 2 sub folders: nvimclipse, nvimclipse_3rdparty
 --install-alias=<alias>  use alias in .bashrc, default is nv
EOF
}

opts=`/usr/bin/getopt -o '' --long help,install-path:,install-alias: -- "$@"`

if [ $? != 0 ] ; then
	echo "getopt failed"
	print_help
	exit 1
fi

install_path="/opt"
install_alias="nv"

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
		--install-alias)
			install_alias=$2
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

found_previous_install=false
print_info "Checking for previous installation:"
probe_dir_not_exists  "$install_path/nvimclipse"          "found_previous_install"
probe_dir_not_exists  "$install_path/nvimclipse_3rdparty" "found_previous_install"
probe_file_not_exists "$HOME/.config/nvim/coc-settings.json"  "found_previous_install"
probe_executable_not_exists "$install_alias" "found_previous_install"
if [ $found_previous_install == true ] ; then
	print_fail "Found at least parts of previous nvimclipse installation (corrupted?), setup will exit."
	print_fail "Before executing install script again clean following files/folders:"
	print_fail "  ~/.config/nvim/coc-settings.json"
	print_fail "  $install_path/nvimclipse"
	print_fail "  $install_path/nvimclipse_3rdparty"
	print_fail "  'nv' alias from ~/.bashrc, or select another with --install-alias"
	exit 1
fi

missing_packages=false
missing_gnu_cpp7=false
missing_gnu_cpp8=false
print_info "Checking for dependencies:"
probe_executable_exists "python3" "missing_packages"
probe_executable_exists "pip3"    "missing_packages"
probe_executable_exists "g++-7"   "missing_gnu_cpp7"
probe_executable_exists "g++-8"   "missing_gnu_cpp8"

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

mkdir_failed=false
print_info "Creating folders:"
probe_mkdir "$install_path/nvimclipse"          "mkdir_failed"
probe_mkdir "$install_path/nvimclipse_3rdparty" "mkdir_failed"
if [ $mkdir_failed == true ] ; then
	print_fail "Some folders were not created, setup will exit"
	rm -rf "$install_path/nvimclipse"
	rm -rf "$install_path/nvimclipse_3rdparty"
	exit 1
fi

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

clang_path=$install_path/nvimclipse_3rdparty/$clang_runtime
nodejs_path=$install_path/nvimclipse_3rdparty/$nodejs_runtime
neovim_path=$install_path/nvimclipse_3rdparty/$neovim_runtime
ccls_path=$install_path/nvimclipse_3rdparty/ccls

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
	-DCMAKE_PREFIX_PATH=$clang_path \
	-DCMAKE_CXX_COMPILER=$gcc"
eval $cmake_command --build Release -j4
if [ ! -f Release/ccls ] ; then
	print_fail "Build failed, setup will exit"
	exit 1
fi
mkdir -p $ccls_path
mkdir -p $ccls_path/bin
cp Release/ccls $ccls_path/bin
cd ../..
rm -rf temp/ccls

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
echo "alias nv=\"PATH=$PATH:$nodejs_path/bin:$HOME/.yarn/bin $neovim_path/bin/nvim -u $install_path/nvimclipse/init.vim\"" >> ~/.bashrc
echo "" >> ~/.bashrc

mkdir -p ~/.config/nvim
ln -sf $install_path/nvimclipse/coc-settings.json ~/.config/nvim/coc-settings.json

PATH=$PATH:$nodejs_pathe/bin $neovim_path/bin/nvim -u $install_path/nvimclipse/install.vim \
		+PlugInstall \
		+UpdateRemotePlugins \
		+qa

PATH=$PATH:$nodejs_pathe/bin $neovim_path/bin/nvim -u $install_path/nvimclipse/install.vim \
		+":call coc#util#install()" \
		+qa
PATH=$PATH:$nodejs_pathe/bin $neovim_path/bin/nvim -u $install_path/nvimclipse/install.vim \
		+":call coc#util#build()" \
		+qa

rm $install_path/nvimclipse/install.vim

