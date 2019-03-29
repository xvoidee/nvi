set runtimepath^=%nvimclipse_path%
set runtimepath+=%nvimclipse_path%/vim-plug
let &packpath = &runtimepath
source %nvimclipse_path%/.vimrc

