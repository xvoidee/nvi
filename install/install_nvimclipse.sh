#!/bin/bash

install_nvimclipse() {
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
	sed -i "s|%ccls_path%|$ccls_path|g"                     $install_path/nvimclipse/coc-settings.json
	sed -i "s|%nvimclipse_path%|$install_path/nvimclipse|g" $install_path/nvimclipse/install.vim

	# TODO catch if not created
	mkdir -p ~/.config/nvim
	ln -sf $install_path/nvimclipse/coc-settings.json ~/.config/nvim/coc-settings.json

	PATH=$PATH:$nodejs_path/bin $nvim_path/bin/nvim -u $install_path/nvimclipse/install.vim \
		+PlugInstall \
		+UpdateRemotePlugins \
		+":call coc#util#install()" \
		+qa
#	rm $install_path/nvimclipse/install.vim
}

