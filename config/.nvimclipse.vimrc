" vi:syntax=vim

" Syntax on
syntax on

" Make vertical split more nice
hi VertSplit cterm=none

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
source config/.nvimclipse.plugins
source config/.nvimclipse.theme
source config/.nvimclipse.hotkeys
source config/.cfg.bufferline
source config/.cfg.coc
source config/.cfg.lightline
source config/.cfg.nerdtree
source config/.cfg.smoothie
source config/.cfg.startify
source config/.cfg.vista

" Source user's setup
source config/.user.theme
source config/.user.hotkeys
source config/.user.vimrc
