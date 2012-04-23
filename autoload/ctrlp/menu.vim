" =============================================================================
" File:          autoload/ctrlp/menu.vim
" Description:   ctrlp menu extension for ctrlp.vim
" =============================================================================

" Change the name of the g:loaded_ variable to make it unique
if ( exists('g:loaded_ctrlp_menu') && g:loaded_ctrlp_menu )
      \ || v:version < 700 || &cp
  finish
endif
let g:loaded_ctrlp_menu = 1

let s:builtins = ['files', 'buffers', 'mru files']

" The main variable for this extension.
"
" The values are:
" + the name of the input function (including the brackets and any argument)
" + the name of the action function (only the name)
" + the long and short names to use for the statusline
" + the matching type: line, path, tabs, tabe
"                      |     |     |     |
"                      |     |     |     `- match last tab delimited str
"                      |     |     `- match first tab delimited str
"                      |     `- match full line like file/dir path
"                      `- match full line
let s:ctrlp_var = {
      \ 'init': 'ctrlp#menu#init()',
      \ 'accept': 'ctrlp#menu#accept',
      \ 'lname': 'ctrlp plugin menu',
      \ 'sname': 'menu',
      \ 'type': 'line',
      \ 'sort' : 0
      \ }


" Append s:ctrlp_var to g:ctrlp_ext_vars
if exists('g:ctrlp_ext_vars') && !empty(g:ctrlp_ext_vars)
  let g:ctrlp_ext_vars = add(g:ctrlp_ext_vars, s:ctrlp_var)
else
  let g:ctrlp_ext_vars = [s:ctrlp_var]
endif


" Provide a list of strings to search in
"
" Return: command
function! ctrlp#menu#init()
  return s:builtins + map(copy(g:ctrlp_ext_vars), 'v:val.lname')
endfunction


" The action to perform on the selected string.
"
" Arguments:
"  a:mode   the mode that has been chosen by pressing <cr> <c-v> <c-t> or <c-x>
"           the values are 'e', 'v', 't' and 'h', respectively
"  a:str    the selected string
func! ctrlp#menu#accept(mode, str)
  call ctrlp#exit()
  " builtins
  let n = index(s:builtins, a:str)
  if n > -1
    call ctrlp#init(n)
    return
  endif
  " plugins
  let n = 0
  for i in range(len(g:ctrlp_ext_vars))
    if g:ctrlp_ext_vars[i].lname == a:str
      let n = i
      break
    endif
  endfor
  call ctrlp#init(call('ctrlp#'.g:ctrlp_extensions[n].'#id',[]))
endfunc


" Give the extension an ID
let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
" Allow it to be called later
function! ctrlp#menu#id()
  return s:id
endfunction

" Create a command to directly call the new search type.
"
" Put something like this in vimrc or plugin/ctrlp.vim
command! CtrlPMenu call ctrlp#init(ctrlp#menu#id())

" vim:fen:fdl=0:ts=2:sw=2:sts=2
