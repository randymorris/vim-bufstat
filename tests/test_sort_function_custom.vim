" Functions
function ReverseAlphabetic(one, two)
    return a:one.name < a:two.name
endfunction

" Bufstat Options
let g:bufstat_sort_function = "ReverseAlphabetic"

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
let g:statusline = "%<%#StatusLine#5 splat  1 foo  3 baz  2 bar[#]  %#StatuslineNC#4 bang%#StatusLine#%#StatusLine#%= "
