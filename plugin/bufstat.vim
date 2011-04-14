" bufstat.vim - persistent buffer list in the status line {{{1
"
" AUTHOR: Randy Morris  -  Copyright (C) 2011
"
" CREDITS: "{{{2
"
"          The concept as well as a small portion of this code was derived
"          from buftabs.vim[1] and/or my modifications to that script.  Credit
"          Ico Doornekamp for the original idea and implementation.
"
"          While buftabs.vim and bufstat.vim try to accomplish the same goal,
"          (display a buffer list while saving screen space) bufstat is more
"          limited as it only allows placing the buffer list in the statusbar.
"          It also has fewer styling options than buftabs.vim.
"
"          [1]: http://www.vim.org/scripts/script.php?script_id=1664
"
"          }}}
"
" LICENSE: "{{{2
"
"          This program is free software; you can redistribute it and/or
"          modify it under the terms of the GNU General Public License as
"          published by the Free Software Foundation; either version 2 of the
"          License, or (at your option) any later version.
"
"          This program is distributed in the hope that it will be useful, but
"          WITHOUT ANY WARRANTY; without even the implied warranty of
"          MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
"          General Public License for more details.
"
"          You should have received a copy of the GNU General Public License
"          along with this program; if not, write to the Free Software
"          Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
"          02110-1301, USA.
"
"          }}}
"}}}

" Loaded trap {{{1

if exists('g:loaded_bufstat')
  finish
endif

" save user's statusline setting to be used as the right side of the statusbar
let s:old_statusline = &statusline
let g:loaded_bufstat = 1

" used when scrolling the buffer list
let s:chop_buffers = 0

"}}}

" Options {{{1

let s:debug = 0 "{{{2
if exists('g:bufstat_debug')
  let s:debug = g:bufstat_debug
endif
"}}}

let s:update_old_windows = 1 "{{{2
if exists('g:bufstat_update_old_windows')
  let s:update_old_windows = g:bufstat_update_old_windows
endif
"}}}

let s:active_hl_group = 'StatuslineNC' "{{{2
if exists('g:bufstat_active_hl_group')
  if hlexists(g:bufstat_active_hl_group)
    let s:active_hl_group = g:bufstat_active_hl_group
  else
    if s:debug > 0
      echo 'bufstat.vim: Active highlight group `'. g:bufstat_active_hl_group . '` does not exist!' 
      echo 'bufstat.vim: Falling back to default: StatuslineNC'
    endif
  endif 
endif
"}}}

let s:inactive_hl_group = 'StatusLine' "{{{2
if exists('g:bufstat_inactive_hl_group')
  if hlexists(g:bufstat_inactive_hl_group)
    let s:inactive_hl_group = g:bufstat_inactive_hl_group
  else
    if s:debug > 0
      echo 'bufstat.vim: Inactive highlight group `' . g:bufstat_inactive_hl_group . '` does not exist!'
      echo 'bufstat.vim: Falling back to default: Statusline'
    endif
  endif
endif
"}}}

let s:modified_list_char = '+' "{{{2
if exists('g:bufstat_modified_list_char')
  let s:modified_list_char  = g:bufstat_modified_list_char
endif
"}}}

let s:alternate_list_char = '#' "{{{2
if exists('g:bufstat_alternate_list_char')
  let s:alternate_list_char  = g:bufstat_alternate_list_char
endif
"}}}

let s:bracket_around_bufname = 0 "{{{2
if exists('g:bufstat_bracket_around_bufname')
  let s:bracket_around_bufname  = g:bufstat_bracket_around_bufname
endif

if s:bracket_around_bufname == 0
  let s:buflist_join_spaces = '  '
else
  let s:buflist_join_spaces = ' '
endif
"}}}

let s:number_before_bufname = 1 "{{{2
if exists('g:bufstat_number_before_bufname')
  let s:number_before_bufname  = g:bufstat_number_before_bufname
endif
"}}}

"}}}

" Script Functions {{{1

function BufstatGenerateList(...) "{{{2
  "
  " Generate a buffer list and store it in s:buffer_list.
  "
  let s:buffer_list = []
  let s:current_buffer = -1

  " special case for BufDelete event, don't include the deleted buffer in the
  " list even though it's not gone yet
  let deleted = -1
  if a:0 > 0
    let deleted = a:1
  endif

  let bufnum = 1
  while bufnum <= bufnr('$')
    if buflisted(bufnum) && getbufvar(bufnum, '&modifiable') && bufnum != deleted
      let name = bufname(bufnum)
      if name == ''
        let name = '-No Name-'
      else
        let name = fnamemodify(name, ':t')
      endif

      " % is an escape character in the status line. Nuke it.
      let name = substitute(name, '%', '%%', 'g')

      if s:number_before_bufname  
        let buftitle = bufnum . ' ' . name
      else
        let buftitle = name
      endif
      let bufflags = ''

      " add a hash for the alternate buffer
      if bufnum == bufnr('#')
        let bufflags .= s:alternate_list_char 
      endif

      " add a bang for modified buffers
      if getbufvar(bufnum, '&modified')
        let bufflags .= s:modified_list_char
      endif

      if s:bracket_around_bufname
        let buftitle = '[' . buftitle . bufflags . ']'
      elseif len(bufflags) > 0
        let buftitle .= '[' . bufflags . ']'
      endif

      if bufnum == winbufnr(winnr())
        let s:current_buffer = len(s:buffer_list)
        let s:buffer_list = add(s:buffer_list, '%#' . s:active_hl_group . '#' . buftitle . '%#' . s:inactive_hl_group . '#')
      else
        let s:buffer_list = add(s:buffer_list, buftitle)
      endif
    endif

    let bufnum += 1
  endwhile

  call BufstatDrawList()
endfunction
"}}}

function BufstatDrawList() "{{{2
  "
  " Updates the status line and forces the statusline to redraw
  "
  let new_statusline = BufstatBuildStatusline()
  let &l:statusline = new_statusline
  redrawstatus!
endfunction
"}}}

function BufstatBuildStatusline() "{{{2
  "
  " Build a string from the s:buffer_list
  "
  " Respects s:chop_buffers.  Includes formatting for highlight groups which
  " will be formatted as the &statusline option.
  "
  let buffer_list_copy = copy(s:buffer_list)
  if s:chop_buffers > 0
    call remove(buffer_list_copy, len(buffer_list_copy) - s:chop_buffers, len(buffer_list_copy) - 1)
  endif
  let buffer_string = join(buffer_list_copy, s:buflist_join_spaces)

  let status_string = '%<%#' . s:inactive_hl_group . '#'
  let status_string .= buffer_string

  " if there are more buffers than are shown, show an > just like vim shows a
  " < at the start of the statusline when it's truncated
  if s:chop_buffers > 0
    let status_string .= '>'
  endif

  " old statusline, right aligned
  let status_string .=  '%#StatusLine#%=  ' . s:old_statusline
  return status_string
endfunction
"}}}

function BufstatRefreshStatuslines() "{{{2
  "
  " Traverses each open window and regenerates the buffer list
  "
  " This is useful when a new window is opened via sp or vsp.  The new window
  " will correctly list the new buffer but the old window will not.
  "
  let current_window = winnr()

  let i = 1
  while i <= winnr('$')
    " skip current window, it's already correct
    if i != current_window
      execute i . "wincmd w"
      call BufstatGenerateList()
    endif
    let i += 1
  endwhile

  execute current_window . "wincmd w"
endfunction
"}}}

function BufstatScroll(dir) "{{{2
  "
  " Increases or decreases s:chop_buffers
  "
  " Useful for pseudo-scrolling through open buffers if there are too many
  " open buffers to display on screen at once.  This will force at least one
  " buffer to be displayed at a time.
  "
  " <dir> can be 'left' or 'right'
  "
  if a:dir == 'left'
    if s:chop_buffers < len(s:buffer_list) - 1
      let s:chop_buffers += 1
    endif
  elseif a:dir == 'right'
    if s:chop_buffers > 0
      let s:chop_buffers -= 1
    endif
  endif

  call BufstatDrawList()
endfunction
"}}}

"}}}

" Autocommands {{{1

augroup Bufstat
  autocmd BufNew,BufEnter,VimResized * :call BufstatGenerateList()
  autocmd BufDelete * :call BufstatGenerateList(expand('<abuf>'))
  autocmd VimEnter * :call BufstatRefreshStatuslines()

  if s:update_old_windows == 1
    autocmd CursorHold,CursorHoldI * :call BufstatRefreshStatuslines()
  endif
augroup END

"}}}

" Mappings "{{{

nnoremap <silent> <plug>bufstat_scroll_right :call BufstatScroll('right')<cr>
nnoremap <silent> <plug>bufstat_scroll_left :call BufstatScroll('left')<cr>

if !hasmapto('<plug>bufstat_scroll_right', 'n')
  silent! nmap <unique> <right> <plug>bufstat_scroll_right
endif

if !hasmapto('<plug>bufstat_scroll_left', 'n')
  silent! nmap <unique> <left> <plug>bufstat_scroll_left
endif

"}}}

" vim:et:sw=2:ts=4:sts=4:fdl=0
