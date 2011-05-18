" Bufstat Options
let g:bufstat_join_string = "    "

" Load Bufstat
source setup.vim

" Open buffers
silent! edit foo
silent! edit bar

" Test
let g:statusline = "%<%#StatusLine#1 foo[#]    %#StatuslineNC#2 bar%#StatusLine#%#StatusLine#%= "
