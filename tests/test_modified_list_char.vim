" Bufstat Options
let g:bufstat_modified_list_char = "&"

" Load Bufstat
source setup.vim

" Open buffers
silent! edit foo
call setline('.', 'foo')

" Test
let g:statusline = "%<%#StatusLine#%#StatuslineNC#1 foo[#&]%#StatusLine#%#StatusLine#%= "
