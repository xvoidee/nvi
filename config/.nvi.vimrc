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

" Relative row numbers and relative row numbers
set number
set relativenumber

" Highlight search
set hlsearch

" Do not display mode in command line
set noshowmode 

" Autosave buffer on switch
set autowrite

" Display filename in window title
set title

" Highlight cursor line
set cursorline

" Do not touch end of view port
set scrolloff=3

" Enable mouse interaction
set mouse=a

" Source nvi settings
source config/.user.nvi.vimrc

" Source any local vimrc's
source config/.nvi.plugins
source config/.nvi.theme
source config/.nvi.hotkeys
source config/.cfg.bufferline
source config/.cfg.coc
source config/.cfg.lightline
source config/.cfg.localvimrc
source config/.cfg.nerdtree
source config/.cfg.smoothie
source config/.cfg.startify
source config/.cfg.vista

" Source user configs
source config/.user.vimrc
source config/.user.theme
source config/.user.hotkeys
