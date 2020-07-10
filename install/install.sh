#!/bin/bash

print_info "Check for previous installation"
no_previous_installation_found=true

check_directory_not_exists "$install_path/3rdparty/ccls"          "no_previous_installation_found"
check_directory_not_exists "$install_path/3rdparty/$ccls_runtime" "no_previous_installation_found"
check_directory_not_exists "$install_path/3rdparty/nvim"          "no_previous_installation_found"
check_directory_not_exists "$install_path/3rdparty/$nvim_runtime" "no_previous_installation_found"
check_directory_not_exists "$install_path/3rdparty/node"          "no_previous_installation_found"
check_directory_not_exists "$install_path/3rdparty/$node_runtime" "no_previous_installation_found"

if [ $no_previous_installation_found == false ] ; then
	print_info "Found complete/partial nvimclipse installation, setup will exit."
	print_info "Check and/or clean following files/folders:"
	print_info "  $install_path/3rdparty/ccls"
	print_info "  $install_path/3rdparty/$ccls_runtime"
	print_info "  $install_path/3rdparty/nvim"
	print_info "  $install_path/3rdparty/$nvim_runtime"
	print_info "  $install_path/3rdparty/node"
	print_info "  $install_path/3rdparty/$node_runtime"
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
extract "temp/$node_archive"     "$install_path/3rdparty"
extract "temp/$nvim_archive"     "$install_path/3rdparty"
extract "3rdparty/$ccls_archive" "$install_path/3rdparty"

ln -sf "$install_path/3rdparty/$node_runtime" "$install_path/3rdparty/node"
ln -sf "$install_path/3rdparty/$nvim_runtime" "$install_path/3rdparty/nvim"
ln -sf "$install_path/3rdparty/$ccls_runtime" "$install_path/3rdparty/ccls"

node_path="$install_path/3rdparty/node"
nvim_path="$install_path/3rdparty/nvim"
ccls_path="$install_path/3rdparty/ccls"

echo "\" vi:syntax=vim
\" This config file is not managed by repository and can be edited
" > config/.user.hotkeys

echo "\" vi:syntax=vim
\" This config file is not managed by repository and can be edited
" > config/.user.plugins

echo "\" vi:syntax=vim
\" This config file is not managed by repository and can be edited
" > config/.user.vimrc

echo "\" vi:syntax=vim
\" This config file is not managed by repository and can be edited

\" Default theme is tender
colo tender
let g:lightline.colorscheme = 'tender'" > config/.user.theme

mkdir -p "autoload"
ln -rsf "vim-plug/plug.vim" "$install_path/autoload/plug.vim"

$nvim_path/bin/nvim -u install/install.vim \
		+PlugInstall \
		+qa
