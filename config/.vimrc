" Plugins will be downloaded under the specified directory
call plug#begin('~/.nvimclipse/plugged')

" Declare the list of plugins
Plug 'ayu-theme/ayu-vim'    , { 'commit' : '4c418ff' }
Plug 'itchyny/lightline.vim', { 'commit' : '83ae633' }
Plug 'itchyny/vim-gitbranch', { 'commit' : '8118dc1' }
Plug 'scrooloose/nerdtree'  , { 'commit' : '288669d' }

" List ends here. Plugins become visible to Vim after this call
call plug#end()

" Source any local vimrc's
source ~/.nvimclipse/.vimrc_theme
source ~/.nvimclipse/.vimrc_lightline
source ~/.nvimclipse/.vimrc_nerdtree
source ~/.nvimclipse/.vimrc_hotkeys

