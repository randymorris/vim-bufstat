" Bufstat Options
let g:bufstat_sort_function = "BufstatSortAlphabetic"

" Load Bufstat
source setup.vim

" Open buffers
silent! edit foo
silent! edit bar
silent! edit baz
silent! edit bang
silent! edit splat
silent! buffer bar
silent! buffer bang

" Test
let g:statusline = "%<%#StatusLine#%#StatuslineNC#4 bang%#StatusLine#  2 bar[#]  3 baz  1 foo  5 splat%#StatusLine#%= "
