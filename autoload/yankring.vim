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


function! s:uniq(list)
  let seen = []
  for i in range(len(a:list))
    if index(seen, a:list[i]) == -1
      call add(seen, a:list[i])
    endif
  endfor
  return seen
endfunction


if !exists('g:YANKRING')
  let s:yankring = []
else
  let s:yankring = s:uniq(g:YANKRING)
endif


function! s:store(list)
  let g:YANKRING = a:list
endfunction


function! yankring#collect()
  let yankring_limit = get(g:, 'yankring_limit', 100)
  let reverse_order = get(g:, 'ctrlp_match_window_reversed', 0)

  let yankstr = getreg('"', 1)
  if !empty(s:yankring)
        \ && yankstr == (reverse_order ? s:yankring[-1] : s:yankring[0])
    return
  endif
  "TODO: recognize getregtype() value
  if len(yankstr) < 2
    return
  endif
  let dup = index(s:yankring, yankstr, 0)
  if dup > -1
    call remove(s:yankring, dup)
  endif

  if reverse_order
    call add(s:yankring, yankstr)
  else
    call insert(s:yankring, yankstr)
  endif

  if yankring_limit < len(s:yankring)
    let s:yankring = reverse_order
          \ ? s:yankring[len(s:yankring) - yanring_limit : len(s:yankring)-1]
          \ : s:yankring[: yankring_limit-1]
  endif

  call s:store(s:yankring[: 30])

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
