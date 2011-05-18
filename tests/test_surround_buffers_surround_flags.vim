" Bufstat Options
let g:bufstat_surround_buffers = "${:}"
let g:bufstat_surround_flags = "[:]"

" Load Bufstat
source setup.vim

" Open Bufers
silent! edit foo
silent! edit bar

" Test
let g:statusline = "%<%#StatusLine#${1 foo[#]}  %#StatuslineNC#${2 bar}%#StatusLine#%#StatusLine#%= "
