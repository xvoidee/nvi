#!/bin/sh

rm -rf ~/.nvimclipse

mkdir ~/.nvimclipse
mkdir ~/.nvimclipse/autoload

cp vim-plug/plug.vim ~/.nvimclipse/autoload/

cp config/init.vim ~/.nvimclipse
cp config/.vimrc* ~/.nvimclipse
cp config/.cfg.* ~/.nvimclipse
