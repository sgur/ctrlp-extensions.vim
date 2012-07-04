"=============================================================================
" FILE: autoload/bundlesync.vim
" AUTHOR: sgur <sgurrr@gmail.com>
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim


" Variables: {{{
" g:ctrlp_yankring_limit = 100
" g:ctrlp_yankring_minimum_chars = 2
" }}}


function! s:uniq(list)
  let seen = []
  for i in range(len(a:list))
    if index(seen, a:list[i]) == -1
      call add(seen, a:list[i])
    endif
  endfor
  return seen
endfunction


function! s:cachedir()
  let yankring_cachedir = ctrlp#utils#cachedir() . ctrlp#utils#lash() . 'yankring'
  return yankring_cachedir
endfunction


function! s:store(list)
  if isdirectory(ctrlp#utils#cachedir())
    if !isdirectory(s:cachedir())
      call mkdir(s:cachedir())
    endif
    call writefile(a:list, s:cachedir() . ctrlp#utils#lash() . 'yankring.txt')
  else
    let g:YANKRING = a:list
  endif
endfunction


let s:yankring = []
function! s:load()
  if isdirectory(s:cachedir())
    let cachefile = s:cachedir() . ctrlp#utils#lash() . 'yankring.txt'
    if filereadable(cachefile)
      let s:yankring = readfile(cachefile)
    endif
  endif
  if exists('g:YANKRING')
    let s:yankring = s:uniq(g:YANKRING)
  endif
endfunction
call s:load()


function! s:remove_duplicated(list, entry)
  let dup = index(a:list, a:entry, 0)
  if dup > -1
    call remove(a:list, dup)
  endif
endfunction


function! s:add(list, entry, reversed)
  if a:reversed
    call add(a:list, a:entry)
  else
    call insert(a:list, a:entry)
  endif
endfunction


function! s:cut_off(list, limit, reversed)
  let list_len = len(a:list)
  if a:limit < list_len
    return a:reversed
          \ ? (a:list[list_len - a:limit : list_len-1])
          \ : (a:list[: a:limit-1])
  else
    return a:list
  endif
endfunction


function! yankring#collect()
  let yankring_limit = get(g:, 'ctrlp_yankring_limit', 100)
  let reverse_order = get(g:, 'ctrlp_match_window_reversed', 0)
  let yankstr = getreg('"', 1)

  if !empty(s:yankring)
        \ && yankstr == (reverse_order ? s:yankring[-1] : s:yankring[0])
    return
  endif

  if len(yankstr) < get(g:, 'ctrlp_yankring_minimum_chars', 2)
    return
  endif

  call s:remove_duplicated(s:yankring, yankstr)
  call s:add(s:yankring, yankstr, reverse_order)
  let s:yankring = s:cut_off(s:yankring, yankring_limit, reverse_order)
  call s:store(s:yankring)
endfunction


function! yankring#list()
  return copy(s:yankring)
endfunction


function! yankring#scope()  "{{{
  return s:
endfunction "}}}


function! yankring#sid()  "{{{
  return maparg('<SID>', 'n')
endfunction "}}}
nnoremap <SID>  <SID>


let &cpo = s:save_cpo
unlet s:save_cpo
