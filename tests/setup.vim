" Load Bufstat
let bufstat_path = expand("%:p:h") . "/../plugin/"
let &rtp = bufstat_path
runtime bufstat.vim

" Test function
autocmd VimEnter * call Test()
function Test()
    if &statusline != g:statusline
        cquit
        " echoerr &statusline
        " echoerr g:statusline
    else
        qall!
    endif
endfunction
