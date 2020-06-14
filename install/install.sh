#!/bin/bash

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

ln -sf "$install_path/nvimclipse_3rdparty/$node_runtime" "$install_path/nvimclipse_3rdparty/node"
ln -sf "$install_path/nvimclipse_3rdparty/$nvim_runtime" "$install_path/nvimclipse_3rdparty/nvim"
ln -sf "$install_path/nvimclipse_3rdparty/$ccls_runtime" "$install_path/nvimclipse_3rdparty/ccls"

node_path="$install_path/nvimclipse_3rdparty/node"
nvim_path="$install_path/nvimclipse_3rdparty/nvim"
ccls_path="$install_path/nvimclipse_3rdparty/ccls"

mkdir -p "$install_path/nvimclipse/autoload"
cp vim-plug/plug.vim   "$install_path/nvimclipse/autoload/"
cp config/.alias       "$install_path/nvimclipse"
cp config/.cfg*        "$install_path/nvimclipse"
cp config/.nvimclipse* "$install_path/nvimclipse"
cp config/*            "$install_path/nvimclipse"
cp install/install.vim "$install_path/nvimclipse"

portable_sed "$install_path/nvimclipse/.alias"              "%install_path%"  "$install_path"
portable_sed "$install_path/nvimclipse/.alias"              "%install_alias%" "$install_alias"
portable_sed "$install_path/nvimclipse/.alias"              "%node_path%"     "$node_path"
portable_sed "$install_path/nvimclipse/.alias"              "%nvim_path%"     "$nvim_path"
portable_sed "$install_path/nvimclipse/.nvimclipse.vimrc"   "%install_path%"  "$install_path"
portable_sed "$install_path/nvimclipse/.nvimclipse.plugins" "%install_path%"  "$install_path"
portable_sed "$install_path/nvimclipse/init.vim"            "%install_path%"  "$install_path"
portable_sed "$install_path/nvimclipse/coc-settings.json"   "%ccls_path%"     "$ccls_path"
portable_sed "$install_path/nvimclipse/install.vim"         "%install_path%"  "$install_path"

echo "source $install_path/nvimclipse/.alias" >> ~/$install_alias_to

mkdir -p ~/.config/nvim
ln -sf "$install_path/nvimclipse/coc-settings.json" ~/.config/nvim/coc-settings.json

PATH=$PATH:$node_path/bin $nvim_path/bin/nvim -u $install_path/nvimclipse/install.vim \
		+PlugInstall \
		+UpdateRemotePlugins \
		+qa

rm $install_path/nvimclipse/install.vim
