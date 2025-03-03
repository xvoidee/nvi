#!/bin/bash

install_path=`pwd`
dependencies_path="${install_path}/3rdparty"

if [ ! -d $install_path/3rdparty ] ; then
  mkdir -p $install_path/3rdparty
fi

if [ -d $dependencies_path/nvim-$nvim_version ] ; then
  print_info "Found active neovim installation: $dependencies_path/nvim-$nvim_version"
  print_info "Skipping neovim installation"
else
  print_info "Installing neovim $nvim_version"

  download_succeeded=true
  download $nvim_website $nvim_archive "download_succeeded"
  
  if [ $download_succeeded == false ] ; then
    print_fail "Download from $nvim_website/$nvim_archive failed, setup will exit"
    exit 1
  else
    print_success "Download from $nvim_website/$nvim_archive succeeded"
    extract temp/$nvim_archive $dependencies_path
    mv "$dependencies_path/$nvim_runtime" "$dependencies_path/nvim-$nvim_version"
  fi

  if [ -L $dependencies_path/nvim ] ; then
    print_info "Found active neovim symlink: $dependencies_path/nvim"
    print_info "Overwriting it"

    rm $dependencies_path/nvim
  fi
  ln -sf $dependencies_path/nvim-$nvim_version $dependencies_path/nvim

  print_success "Installed neovim $nvim_version"
fi

if [ -d $dependencies_path/$node_runtime ] ; then
  print_info "Found active nodejs installation: $dependencies_path/$node_runtime"
  print_info "Skipping nodejs installation"
else
  print_info "Installing nodejs $node_version"

  download_succeeded=true
  download $node_website $node_archive "download_succeeded"
  
  if [ $download_succeeded == false ] ; then
    print_fail "Download from $node_website/$node_archive failed, setup will exit"
    exit 1
  else
    print_success "Download from $node_website/$node_archive succeeded"
    extract temp/$node_archive $dependencies_path
  fi

  if [ -L $dependencies_path/node ] ; then
    print_info "Found active nodejs symlink: $dependencies_path/node"
    print_info "Overwriting it"

    rm $dependencies_path/node
  fi
  ln -sf $dependencies_path/$node_runtime $dependencies_path/node

  print_success "Installed nodejs $node_version"
fi

copy_if_not_exists "install/.user.hotkeys"   "config"
copy_if_not_exists "install/.user.plugins"   "config"
copy_if_not_exists "install/.user.vimrc"     "config"
copy_if_not_exists "install/.user.theme"     "config"

if [ ! -L autoload/plug.vim ] ; then
  mkdir -p autoload
  cd autoload
  ln -s ../vim-plug/plug.vim ./
  cd ..
fi

if [ ! -e autoload/plug.vim ] ; then
  print_fail "autoload/plug.vim does not exists, did you run git submodule init & update?"
  exit 1
fi

export NVI_RTP_DIR=$install_path
$dependencies_path/nvim/bin/nvim -u install/install.vim \
  +PlugInstall \
  +qa
unset NVI_RTP_DIR
