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

" Set nerd fonts
let g:nvi_nerd_fonts = 0

" Setup lighline separators
if g:nvi_nerd_fonts == 1
  let g:nvi_lightline_separator_left  = "\uE0B8"
  let g:nvi_lightline_separator_right = "\uE0BA"

  let g:nvi_lightline_subseparator_left  = "\uE0B9"
  let g:nvi_lightline_subseparator_right = "\uE0BB"
else
  let g:nvi_lightline_separator_left  = '░'
  let g:nvi_lightline_separator_right = '░'

  let g:nvi_lightline_subseparator_left  = '░'
  let g:nvi_lightline_subseparator_right = '░'
endif

" Source all other configs
exec 'source' g:nvi_rtp_dir . '/config/.nvi.plugins'
exec 'source' g:nvi_rtp_dir . '/config/.nvi.hotkeys'
exec 'source' g:nvi_rtp_dir . '/config/.cfg.bufferline'
exec 'source' g:nvi_rtp_dir . '/config/.cfg.coc'
exec 'source' g:nvi_rtp_dir . '/config/.cfg.fzf'
exec 'source' g:nvi_rtp_dir . '/config/.cfg.lightline'
exec 'source' g:nvi_rtp_dir . '/config/.cfg.localvimrc'
exec 'source' g:nvi_rtp_dir . '/config/.cfg.nerdtree'
exec 'source' g:nvi_rtp_dir . '/config/.cfg.startify'
exec 'source' g:nvi_rtp_dir . '/config/.cfg.vimmove'
exec 'source' g:nvi_rtp_dir . '/config/.cfg.vista'

" Source user configs
exec 'source' g:nvi_rtp_dir . '/config/.user.vimrc'
exec 'source' g:nvi_rtp_dir . '/config/.user.theme'
exec 'source' g:nvi_rtp_dir . '/config/.user.hotkeys'
