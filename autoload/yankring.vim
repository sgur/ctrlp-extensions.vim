"=============================================================================
" FILE: autoload/yankring.vim
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
let g:ctrlp_yankring_limit = get(g:, 'ctrlp_yankring_limit', 100)
let g:ctrlp_yankring_minimum_chars = get(g:, 'ctrlp_yankring_minimum_chars', 2)
" }}}



let s:yankring = []



function! s:uniq(list)
  let seen = []
  for i in range(len(a:list))
    if index(seen, a:list[i]) == -1
      call add(seen, a:list[i])
    endif
  endfor
  return seen
endfunction


function! s:is_session_cache_enabled()
  return exists('g:ctrlp_clear_cache_on_exit') && !g:ctrlp_clear_cache_on_exit
endfunction


function! s:cachedir()
  let yankring_cachedir = ctrlp#utils#cachedir() . ctrlp#utils#lash() . 'yankring'
  return yankring_cachedir
endfunction


function! s:cachefile()
  return s:cachedir() . ctrlp#utils#lash() . 'yankring.txt'
endfunction


function! s:load()
  if exists('s:yankring_cache_loaded')
    return
  endif
  if isdirectory(s:cachedir()) && s:is_session_cache_enabled()
    if filereadable(s:cachefile())
      let s:yankring = s:uniq(s:yankring + readfile(s:cachefile()))
    endif
  endif
  let s:yankring_cache_loaded = 1
endfunction


function! s:remove_duplicated(list, entry)
  let dup = index(a:list, a:entry, 0)
  if dup > -1
    call remove(a:list, dup)
  endif
endfunction


function! s:cut_off(list, limit)
  return a:limit < len(a:list) ? a:list[: a:limit-1] : a:list
endfunction



function! yankring#collect()
  let yankstr = getreg('"', 1)

  if !empty(s:yankring) && yankstr == s:yankring[0]
    return
  endif

  if len(yankstr) < g:ctrlp_yankring_minimum_chars
    return
  endif

  call s:remove_duplicated(s:yankring, yankstr)
  call insert(s:yankring, yankstr)
endfunction


function! yankring#store()
  if isdirectory(ctrlp#utils#cachedir()) && s:is_session_cache_enabled()
    if !isdirectory(s:cachedir())
      call mkdir(s:cachedir())
    endif
    call s:load()
    call writefile(s:yankring, s:cachefile())
  endif
endfunction


function! yankring#list()
  call s:load()
  let s:yankring = s:cut_off(s:yankring, g:ctrlp_yankring_limit)
  let _ = copy(s:yankring)
  if exists('g:ctrlp_match_window') && stridx(g:ctrlp_match_window, 'order:tbb') > -1
    call reverse(_)
  endif
  return _
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
