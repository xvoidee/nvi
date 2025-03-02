" vi:syntax=vim

let g:nvi_rtp_dir = expand("$NVI_RTP_DIR")

set runtimepath^=./
set runtimepath+=./autoload
let &packpath = &runtimepath

let g:nvi_nerd_fonts=1
source config/.nvi.plugins

