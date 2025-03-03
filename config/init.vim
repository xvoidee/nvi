" vi:syntax=vim

let g:nvi_rtp_dir = expand("$NVI_RTP_DIR")

exec 'set runtimepath^=' . g:nvi_rtp_dir
exec 'set runtimepath+=' . g:nvi_rtp_dir . '/autoload'

let &packpath = &runtimepath

exec 'source ' . g:nvi_rtp_dir . '/config/.nvi.vimrc'