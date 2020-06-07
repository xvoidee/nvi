" vi:syntax=vim

set runtimepath^=%install_path%/nvimclipse
set runtimepath+=%install_path%/nvimclipse/vim-plug
let &packpath = &runtimepath
source %install_path%/nvimclipse/.nvimclipse.vimrc

