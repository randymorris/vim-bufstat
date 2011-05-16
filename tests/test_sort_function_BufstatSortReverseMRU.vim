" Bufstat Options
let g:bufstat_sort_function = "BufstatSortReverseMRU"

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
let g:statusline = "%<%#StatusLine#1 foo  3 baz  5 splat  2 bar[#]  %#StatuslineNC#4 bang%#StatusLine#%#StatusLine#%= "
