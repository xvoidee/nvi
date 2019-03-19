" Plugins will be downloaded under the specified directory
call plug#begin('~/.nvimclipse/plugged')

" Declare the list of plugins
Plug 'ayu-theme/ayu-vim'        , { 'commit' : '4c418ff' }
Plug 'itchyny/lightline.vim'    , { 'commit' : '83ae633' }
Plug 'tpope/vim-fugitive'       , { 'commit' : 'bd0b87d' }
Plug 'scrooloose/nerdtree'      , { 'commit' : '288669d' }
Plug 'mhinz/vim-startify'       , { 'commit' : '9c5680c' }
Plug 'ap/vim-buftabline'        , { 'commit' : '14d208b' }
Plug 'airblade/vim-gitgutter'   , { 'commit' : '8a4b9cc' }
Plug 'junegunn/fzf'             , { 'dir' : '~/.fzf', 'do' : './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'neoclide/coc.nvim'        , { 'do' : { -> coc#util#install() } }
Plug 'arakashic/chromatica.nvim', { 'commit' : 'ae7d498' }
Plug 'ryanoasis/vim-devicons'   , { 'commit' : '83808e8' }

" List ends here. Plugins become visible to Vim after this call
call plug#end()

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
source ~/.nvimclipse/.vimrc_theme
source ~/.nvimclipse/.cfg.coc
source ~/.nvimclipse/.cfg.chromatica
source ~/.nvimclipse/.cfg.lightline
source ~/.nvimclipse/.cfg.nerdtree
source ~/.nvimclipse/.cfg.startify
source ~/.nvimclipse/.vimrc_hotkeys
