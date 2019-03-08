" Plugins will be downloaded under the specified directory
call plug#begin('~/.nvimclipse/plugged')

" Declare the list of plugins
Plug 'ayu-theme/ayu-vim'    , { 'commit' : '4c418ff' }
Plug 'itchyny/lightline.vim', { 'commit' : '83ae633' }
Plug 'itchyny/vim-gitbranch', { 'commit' : '8118dc1' }
Plug 'scrooloose/nerdtree'  , { 'commit' : '288669d' }
Plug 'mhinz/vim-startify'   , { 'commit' : '9c5680c' }

" List ends here. Plugins become visible to Vim after this call
call plug#end()

" Source any local vimrc's
source ~/.nvimclipse/.vimrc_theme
source ~/.nvimclipse/.cfg.lightline
source ~/.nvimclipse/.cfg.nerdtree
source ~/.nvimclipse/.cfg.startify
source ~/.nvimclipse/.vimrc_hotkeys

