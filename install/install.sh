#!/bin/bash

install_path=`pwd`

print_info "Check for previous installation"
no_previous_installation_found=true

#check_directory_not_exists "$install_path/3rdparty/ccls"          "no_previous_installation_found"
#check_directory_not_exists "$install_path/3rdparty/$ccls_runtime" "no_previous_installation_found"
check_directory_not_exists "$install_path/3rdparty/nvim"          "no_previous_installation_found"
check_directory_not_exists "$install_path/3rdparty/$nvim_runtime" "no_previous_installation_found"
check_directory_not_exists "$install_path/3rdparty/node"          "no_previous_installation_found"
check_directory_not_exists "$install_path/3rdparty/$node_runtime" "no_previous_installation_found"

if [ $no_previous_installation_found == false ] ; then
	print_info "Found complete/partial nvi installation, setup will exit."
	print_info "Check and/or clean following files/folders:"
#	print_info "  $install_path/3rdparty/ccls"
#	print_info "  $install_path/3rdparty/$ccls_runtime"
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
#extract "3rdparty/$ccls_archive" "$install_path/3rdparty"

mv "$install_path/3rdparty/$nvim_runtime" "$install_path/3rdparty/nvim-$nvim_version"
nvim_runtime="nvim-$nvim_version"

ln -sf "$install_path/3rdparty/$node_runtime" "$install_path/3rdparty/node"
ln -sf "$install_path/3rdparty/$nvim_runtime" "$install_path/3rdparty/nvim"
#ln -sf "$install_path/3rdparty/$ccls_runtime" "$install_path/3rdparty/ccls"

node_path="$install_path/3rdparty/node"
nvim_path="$install_path/3rdparty/nvim"
#ccls_path="$install_path/3rdparty/ccls"

if [ ! -f config/.user.nvi.vimrc ] ; then
echo "\
\" vi:syntax=vim
\" This config file is not managed by repository and can be edited

\" Modify this path if nvi directory was copied/moved
let g:nvi_install_path=\"$install_path\"

\" Setup nerd fonts
let g:nvi_nerd_fonts = 0

\" Setup lighline separators
if g:nvi_nerd_fonts == 1
  let g:nvi_lightline_separator_left  = \"\\uE0B8\"
  let g:nvi_lightline_separator_right = \"\\uE0BA\"

  let g:nvi_lightline_subseparator_left  = \"\\uE0B9\"
  let g:nvi_lightline_subseparator_right = \"\\uE0BB\"
else
  let g:nvi_lightline_separator_left  = '░'
  let g:nvi_lightline_separator_right = '░'

  let g:nvi_lightline_subseparator_left  = '░'
  let g:nvi_lightline_subseparator_right = '░'
endif
" > config/.user.nvi.vimrc
fi

if [ ! -f config/.user.hotkeys ] ; then
echo "\
\" vi:syntax=vim
\" This config file is not managed by repository and can be edited
" > config/.user.hotkeys
fi

if [ ! -f config/.user.plugins ] ; then
echo "\
\" vi:syntax=vim
\" This config file is not managed by repository and can be edited
" > config/.user.plugins
fi

if [ ! -f config/.user.vimrc ] ; then
echo "\
\" vi:syntax=vim
\" This config file is not managed by repository and can be edited
" > config/.user.vimrc
fi

if [ ! -f config/.user.theme ] ; then
echo "\
\" vi:syntax=vim
\" This config file is not managed by repository and can be edited

\" Default theme is tender
colo tender
let g:lightline.colorscheme = 'tender'
" > config/.user.theme
fi

if [ ! -f config/init.vim ] ; then
echo "\
\" vi:syntax=vim

set runtimepath^=$install_path
set runtimepath+=$install_path/autoload
let &packpath = &runtimepath
source $install_path/config/.nvi.vimrc
" > config/init.vim
fi

if [ ! -f autoload/plug.vim ] ; then
	mkdir -p autoload
	cd autoload
	ln -s ../vim-plug/plug.vim ./
	cd ..
fi

if [ ! -f bin/nvi ] ; then
echo "\
#!/bin/bash
# This script is not managed by repository and can be edited

install_path=/home/xvoidee/nvi
$install_path/3rdparty/nvim/bin/nvim -u $install_path/config/init.vim $@
" > bin/nvi
chmod +x bin/nvi
fi

$nvim_path/bin/nvim -u install/install.vim \
		+PlugInstall \
		+qa

