" Bufstat Options
let g:bufstat_surround_flags = "@:@"

" Load Bufstat
source setup.vim

" Open buffers
silent! edit foo

" Test
let g:statusline = "%<%#StatusLine#%#StatuslineNC#1 foo@#@%#StatusLine#%#StatusLine#%= "
