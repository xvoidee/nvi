#!/bin/bash

install_path=`pwd`

print_info "Check for previous installation"
no_previous_installation_found=true

check_directory_not_exists "$install_path/3rdparty/nvim"          "no_previous_installation_found"
check_directory_not_exists "$install_path/3rdparty/$nvim_runtime" "no_previous_installation_found"
check_directory_not_exists "$install_path/3rdparty/node"          "no_previous_installation_found"
check_directory_not_exists "$install_path/3rdparty/$node_runtime" "no_previous_installation_found"

if [ $no_previous_installation_found == false ] ; then
  print_info "Found complete/partial nvi installation, setup will exit."
  print_info "Check and/or clean following files/folders:"
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
mkdir -p $install_path/3rdparty
extract "temp/$node_archive" "$install_path/3rdparty"
extract "temp/$nvim_archive" "$install_path/3rdparty"

mv "$install_path/3rdparty/$nvim_runtime" "$install_path/3rdparty/nvim-$nvim_version"
nvim_runtime="nvim-$nvim_version"

ln -sf "$install_path/3rdparty/$node_runtime" "$install_path/3rdparty/node"
ln -sf "$install_path/3rdparty/$nvim_runtime" "$install_path/3rdparty/nvim"

node_path="$install_path/3rdparty/node"
nvim_path="$install_path/3rdparty/nvim"

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
let g:lightline.colorscheme = 'tenderplus'
hi CocSemTypeClass      guifg=#FF9F4B
hi CocSemTypeEnum       guifg=#EEC000
hi CocSemTypeEnumMember guifg=#EEEFB3
hi CocSemTypeFunction   guifg=#EFB3B3
hi CocSemTypeNamespace  guifg=#A7A7A7
hi CocSemTypeParameter  guifg=#D4A4EF
hi CocSemTypeProperty   guifg=#A4EFD5
hi CocSemTypeVariable   guifg=#D4A4EF
hi Search               guifg=#000000 guibg=#FFFFFF gui=none
hi IncSearch            guifg=#000000 guibg=#FFFFFF gui=none
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

export NVI_HOME=$install_path
export XDG_DATA_HOME=./.nvi
\$NVI_HOME/3rdparty/nvim/bin/nvim -u \$NVI_HOME/config/init.vim $@
unset NVI_HOME
unset XDG_DATA_HOME
" > bin/nvi
chmod +x bin/nvi
fi

export NVI_HOME=$install_path
$nvim_path/bin/nvim -u install/install.vim \
  +PlugInstall \
  +qa
unset NVI_HOME
