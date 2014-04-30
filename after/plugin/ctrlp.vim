if !exists('g:loaded_ctrlp') || g:loaded_ctrlp == 0
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

command! CtrlPCmdline call ctrlp#init(ctrlp#cmdline#id())
command! CtrlPMenu call ctrlp#init(ctrlp#menu#id())
command! CtrlPYankring call ctrlp#init(ctrlp#yankring#id())

let &cpo = s:save_cpo
unlet s:save_cpo
