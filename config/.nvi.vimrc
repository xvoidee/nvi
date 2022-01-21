" vi:syntax=vim

" Syntax on
syntax on

" Make vertical split more nice
hi VertSplit cterm=none

" Enable aux column for git status
set signcolumn=yes

" Tabs policy
set autoindent
set shiftwidth=0
set tabstop=2
set noexpandtab

" Auto indent
set nocindent
set nosmartindent
set formatoptions+=cro

" Current line number is absolute
set number

" All other line numbers are relative
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

" Leave 3 lines on top and bottom of buffer on scroll
set scrolloff=3

" Enable mouse interaction
set mouse=a

echo $NVI_HOME
sleep 5

" Source user settings first!
source $NVI_HOME . /config/.user.nvi.vimrc

" Source all other configs
exec 'source' g:nvi_install_path . '/config/.nvi.plugins'
exec 'source' g:nvi_install_path . '/config/.nvi.theme'
exec 'source' g:nvi_install_path . '/config/.nvi.hotkeys'
exec 'source' g:nvi_install_path . '/config/.cfg.bufferline'
exec 'source' g:nvi_install_path . '/config/.cfg.coc'
exec 'source' g:nvi_install_path . '/config/.cfg.lightline'
exec 'source' g:nvi_install_path . '/config/.cfg.localvimrc'
exec 'source' g:nvi_install_path . '/config/.cfg.nerdtree'
exec 'source' g:nvi_install_path . '/config/.cfg.startify'
exec 'source' g:nvi_install_path . '/config/.cfg.vista'

" Source user configs
exec 'source' g:nvi_install_path . '/config/.user.vimrc'
exec 'source' g:nvi_install_path . '/config/.user.theme'
exec 'source' g:nvi_install_path . '/config/.user.hotkeys'

