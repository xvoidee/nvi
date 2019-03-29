" Enable plugins
source %nvimclipse_path%/.vimrc.plugins

" Syntax on
syntax on

" Make vertical split more nice
hi VertSplit cterm = none

" Enable aux column
set signcolumn=yes

" Tabs policy
set autoindent shiftwidth=0 tabstop=2 noexpandtab

" Auto indent
set nocindent
set nosmartindent
set formatoptions+=cro

" Line numbers
set nu

" Highlight search
set hls

" Source any local vimrc's
source %nvimclipse_path%/.vimrc.theme
source %nvimclipse_path%/.cfg.coc
source %nvimclipse_path%/.cfg.chromatica
source %nvimclipse_path%/.cfg.lightline
source %nvimclipse_path%/.cfg.nerdtree
source %nvimclipse_path%/.cfg.startify
source %nvimclipse_path%/.vimrc.hotkeys
