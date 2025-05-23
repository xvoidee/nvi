" vi:syntax=vim

" Syntax on
syntax on

" Set to 256 colors
set termguicolors

" Make vertical split more nice
hi VertSplit cterm=none

" Enable aux column for git status
set signcolumn=yes

" Tabs policy
set autoindent
set shiftwidth=0
set tabstop=2
set expandtab

" Auto indent
set nocindent
set nosmartindent
set formatoptions+=cro

" Current line number is absolute
set number

" All other line numbers are relative
set relativenumber

" Do not display mode in command line
set noshowmode 

" Autosave buffer on switch
set autowrite

" Display filename in window title
set title

" Do not highlight cursor line
set nocursorline

" Leave 3 lines on top and bottom of buffer on scroll
set scrolloff=3

" Enable mouse interaction
set mouse=a

" Set nerd fonts
let g:nvi_nerd_fonts = 0

" Setup lighline separators
if g:nvi_nerd_fonts == 1
  let g:nvi_lightline_separator_left     = "\uE0B8"
  let g:nvi_lightline_separator_right    = "\uE0BA"

  let g:nvi_lightline_subseparator_left  = "\uE0B9"
  let g:nvi_lightline_subseparator_right = "\uE0BB"
else
  let g:nvi_lightline_separator_left     = '░'
  let g:nvi_lightline_separator_right    = '░'

  let g:nvi_lightline_subseparator_left  = '░'
  let g:nvi_lightline_subseparator_right = '░'
endif

" Source nvi configs
exec 'source' g:nvi_rtp_dir . '/config/.nvi.plugins'
exec 'source' g:nvi_rtp_dir . '/config/.nvi.hotkeys'

" Source plugins configs
exec 'source' g:nvi_rtp_dir . '/config/.cfg.betterescape.lua'
exec 'source' g:nvi_rtp_dir . '/config/.cfg.bufferline'
exec 'source' g:nvi_rtp_dir . '/config/.cfg.coc'
exec 'source' g:nvi_rtp_dir . '/config/.cfg.colorizer.lua'
exec 'source' g:nvi_rtp_dir . '/config/.cfg.diffview.lua'
exec 'source' g:nvi_rtp_dir . '/config/.cfg.flash.lua'
exec 'source' g:nvi_rtp_dir . '/config/.cfg.fzf.lua'
exec 'source' g:nvi_rtp_dir . '/config/.cfg.harpoon.lua'
exec 'source' g:nvi_rtp_dir . '/config/.cfg.lightline'
exec 'source' g:nvi_rtp_dir . '/config/.cfg.localvimrc'
exec 'source' g:nvi_rtp_dir . '/config/.cfg.nerdtree'
exec 'source' g:nvi_rtp_dir . '/config/.cfg.startify'
exec 'source' g:nvi_rtp_dir . '/config/.cfg.vimade'
exec 'source' g:nvi_rtp_dir . '/config/.cfg.vimmove'
exec 'source' g:nvi_rtp_dir . '/config/.cfg.vista'

" Source user configs
exec 'source' g:nvi_rtp_dir . '/config/.user.vimrc'
exec 'source' g:nvi_rtp_dir . '/config/.user.theme'
exec 'source' g:nvi_rtp_dir . '/config/.user.hotkeys'
