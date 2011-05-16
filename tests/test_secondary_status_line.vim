" Options
set statusline=foo

" Load Bufstat
source setup.vim

" Test
let g:statusline = "%<%#StatusLine#%#StatuslineNC#1 -No Name-%#StatusLine#%#StatusLine#%= foo"
