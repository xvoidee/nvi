#!/bin/sh

rm -rf ~/.nvimclipse

mkdir ~/.nvimclipse
mkdir ~/.nvimclipse/autoload

cp config/init.vim ~/.nvimclipse
cp config/.vimrc ~/.nvimclipse
cp config/.vimrc_theme ~/.nvimclipse
cp vim-plug/plug.vim ~/.nvimclipse/autoload/
