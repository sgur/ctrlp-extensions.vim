scriptencoding utf-8


function! yankring#hook#highlight_last_yank()
  let [start, end] = [getpos("'["), getpos("']")]
  if start[1] == end[1]
    call matchadd('DiffAdd', printf('\%%%sl\%%>%sc.*\%%%sl\%%<%sc', start[1], start[2]-1, end[1], end[2]+1))
  else
    call matchadd('DiffAdd', printf('\%%%sl\%%%sc.*$', start[1], start[2]))
    call matchadd('DiffAdd', printf('\%%>%sl.*\%%<%sl', start[1], end[1]))
    call matchadd('DiffAdd', printf('^.*\%%%sl\%%%sc', end[1], end[2]+1))
  endif

  augroup yankring_clearmatches
    autocmd!
    autocmd CursorMoved,CursorMovedI,InsertEnter <buffer> call s:clearmatches()
  augroup END
endfunction


function! s:clearmatches()
  " HACK: clear highlight once
  if !exists('w:yankring')
    let w:yankring = 1
  else
    if w:yankring
      echomsg 'clearmatches'
      autocmd! yankring_clearmatches
      call clearmatches()
      unlet w:yankring
    endif
  endif
endfunction
