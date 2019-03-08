" Plugins will be downloaded under the specified directory.
call plug#begin('~/.nvimclipse/plugged')

" Declare the list of plugins.
Plug 'ayu-theme/ayu-vim', { 'commit' : '4c418ff' }

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

" Source any local vimrc's
source ~/.nvimclipse/.vimrc_theme
