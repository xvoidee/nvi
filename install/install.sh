#!/bin/bash

print_help() {
	cat << EOF
Options:
 --help                     display help
 --install-path=<path>      target directory for installation, default is /opt
                            script will create 2 sub folders: nvimclipse, nvimclipse_3rdparty
 --install-alias=<alias>    install alias to your shell rc, default is nv
 --install-alias-to=<alias> name of rc where alias will be installed, default is .bashrc
EOF
}

source install/install_helpers.sh
source install/install_packages.sh

opts=`/usr/bin/getopt -o '' --long help,install-path:,install-alias:,install-alias-to: -- "$@"`

if [ $? != 0 ] ; then
	echo "getopt failed"
	print_help
	exit 1
fi

install_path="/opt"
install_alias="nv"
install_alias_to=".bashrc"

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
		--install-alias-to)
			install_alias_to=$2
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

print_info "Check for previous installation"
no_previous_installation_found=true
check_directory_not_exists  "$install_path/nvimclipse"          "no_previous_installation_found"
check_directory_not_exists  "$install_path/nvimclipse_3rdparty" "no_previous_installation_found"

# TODO check for coc-settings?
#check_directory_not_exists "$HOME/.config/nvim/coc-settings.json"  "found_previous_install"

# TODO check for coc-settings?
if [ $no_previous_installation_found == false ] ; then
	print_fail "Found complete/partial nvimclipse installation, setup will exit."
	print_fail "Check and/or clean following files/folders:"
	print_fail "  ~/.config/nvim/coc-settings.json"
	print_fail "  $install_path/nvimclipse"
	print_fail "  $install_path/nvimclipse_3rdparty"
	exit 1
fi

if [ $no_missing_packages == false ] ; then
	print_fail "Dependencies check failed, setup will exit"
	exit 1
fi

mkdir_succeeded=true
print_info "Create folders"
probe_mkdir "$install_path/nvimclipse"          "mkdir_succeeded"
probe_mkdir "$install_path/nvimclipse_3rdparty" "mkdir_succeeded"
if [ $mkdir_succeeded == false ] ; then
	print_fail "Some folders were not created, setup will exit"
	print_info "rm -rf \"$install_path/nvimclipse\""
	print_info "rm -rf \"$install_path/nvimclipse_3rdparty\""
	rm -rf "$install_path/nvimclipse"
	rm -rf "$install_path/nvimclipse_3rdparty"
	exit 1
fi

print_info "Download standalone dependencies"
download_succeeded=true
download $node_website $node_archive "download_succeeded"
download $nvim_website $nvim_archive "download_succeeded"
if [ $download_succeeded == false ] ; then
	print_fail "Download failed, setup will exit"
	exit 1
fi

print_info "Extract dependencies"

extract temp/$node_archive     "$install_path/nvimclipse_3rdparty"
extract temp/$nvim_archive     "$install_path/nvimclipse_3rdparty"
extract 3rdparty/$ccls_archive "$install_path/nvimclipse_3rdparty"

ln -sf $install_path/nvimclipse_3rdparty/$node_runtime $install_path/nvimclipse_3rdparty/node
ln -sf $install_path/nvimclipse_3rdparty/$nvim_runtime $install_path/nvimclipse_3rdparty/nvim
ln -sf $install_path/nvimclipse_3rdparty/$ccls_runtime $install_path/nvimclipse_3rdparty/ccls

node_path=$install_path/nvimclipse_3rdparty/node
nvim_path=$install_path/nvimclipse_3rdparty/nvim
ccls_path=$install_path/nvimclipse_3rdparty/ccls

rm -rf $install_path/nvimclipse
mkdir $install_path/nvimclipse

mkdir $install_path/nvimclipse/autoload
cp vim-plug/plug.vim   $install_path/nvimclipse/autoload/
cp config/.alias       $install_path/nvimclipse
cp config/.cfg*        $install_path/nvimclipse
cp config/.nvimclipse* $install_path/nvimclipse
cp config/*            $install_path/nvimclipse
cp install/install.vim $install_path/nvimclipse

sed -i "s|%install_path%|$install_path|g" $install_path/nvimclipse/.alias
sed -i "s|%node_path%|$node_path|g"       $install_path/nvimclipse/.alias
sed -i "s|%nvim_path%|$nvim_path|g"       $install_path/nvimclipse/.alias
sed -i "s|%install_path%|$install_path|g" $install_path/nvimclipse/.nvimclipse.vimrc
sed -i "s|%install_path%|$install_path|g" $install_path/nvimclipse/.nvimclipse.plugins
sed -i "s|%install_path%|$install_path|g" $install_path/nvimclipse/init.vim
sed -i "s|%ccls_path%|$ccls_path|g"       $install_path/nvimclipse/coc-settings.json
sed -i "s|%install_path%|$install_path|g" $install_path/nvimclipse/install.vim

echo "source $install_path/nvimclipse/.alias" >> ~/$install_alias_to

mkdir -p ~/.config/nvim
ln -sf $install_path/nvimclipse/coc-settings.json ~/.config/nvim/coc-settings.json

PATH=$PATH:$node_path/bin $nvim_path/bin/nvim -u $install_path/nvimclipse/install.vim \
		+PlugInstall \
		+UpdateRemotePlugins \
		+qa

rm $install_path/nvimclipse/install.vim
