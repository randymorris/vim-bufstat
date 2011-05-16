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
let g:statusline = "%<%#StatusLine#1 foo  2 bar[#]  3 baz  %#StatuslineNC#4 bang%#StatusLine#  5 splat%#StatusLine#%= "
