" =============================================================================
" File:          autoload/ctrlp/cmdline.vim
" Description:   cmdline extension for ctrlp.vim
" =============================================================================

" Change the name of the g:loaded_ variable to make it unique
if ( exists('g:loaded_ctrlp_cmdline') && g:loaded_ctrlp_cmdline )
	\ || v:version < 700 || &cp
	finish
endif
let g:loaded_ctrlp_cmdline = 1

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
let s:cmdline_var = {
	\ 'init': 'ctrlp#cmdline#init()',
	\ 'accept': 'ctrlp#cmdline#accept',
	\ 'lname': 'cmdline',
	\ 'sname': 'cmd',
	\ 'type': 'line',
	\ 'sort': 0,
	\ }


" Append s:cmdline_var to g:ctrlp_ext_vars
if exists('g:ctrlp_ext_vars') && !empty(g:ctrlp_ext_vars)
	let g:ctrlp_ext_vars = add(g:ctrlp_ext_vars, s:cmdline_var)
else
	let g:ctrlp_ext_vars = [s:cmdline_var]
endif


" Provide a list of strings to search in
"
" Return: command
function! ctrlp#cmdline#init()
  let type = 'cmd'
  let entries = map(range(histnr(type), 0, -1), 'histget(type, v:val)')
  let list = filter(entries, '!empty(v:val)')
  return list
endfunction


" The action to perform on the selected string.
"
" Arguments:
"  a:mode   the mode that has been chosen by pressing <cr> <c-v> <c-t> or <c-x>
"           the values are 'e', 'v', 't' and 'h', respectively
"  a:str    the selected string
func! ctrlp#cmdline#accept(mode, str)
  call ctrlp#exit()
  silent execute ':'.a:str
  call histadd('cmd', a:str)
endfunc


" Give the extension an ID
let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
" Allow it to be called later
function! ctrlp#cmdline#id()
  return s:id
endfunction


" vim:fen:fdl=0:ts=2:sw=2:sts=2
