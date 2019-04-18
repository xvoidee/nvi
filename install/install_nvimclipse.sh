#!/bin/bash

install_nvimclipse() {
	mkdir $nvimclipse_path/autoload
	cp vim-plug/plug.vim $nvimclipse_path/autoload/

	cp config/.cfg.*            $nvimclipse_path
	cp config/.vimrc*           $nvimclipse_path
	cp config/init.vim          $nvimclipse_path
	cp config/coc-settings.json $nvimclipse_path

	sed -i "s|%clang_path%|$clang_path|g"           $nvimclipse_path/.cfg.chromatica
	sed -i "s|%clang_version%|8.0.0|g"              $nvimclipse_path/.cfg.chromatica
	sed -i "s|%nvimclipse_path%|$nvimclipse_path|g" $nvimclipse_path/.vimrc
	sed -i "s|%nvimclipse_path%|$nvimclipse_path|g" $nvimclipse_path/.vimrc.plugins
	sed -i "s|%nvimclipse_path%|$nvimclipse_path|g" $nvimclipse_path/init.vim
	sed -i "s|%ccls_path%|$ccls_path|g"             $nvimclipse_path/coc-settings.json

	# TODO catch if not created
	mkdir -p ~/.config/nvim
	ln -s $nvimclipse_path/coc-settings.json ~/.config/nvim/coc-settings.json

	PATH=$PATH:$nodejs_path/bin $neovim_path/bin/nvim -u ./install.vim \
		+PlugInstall \
		+UpdateRemotePlugins \
		+":call coc#util#install()" \
		+qa
}

