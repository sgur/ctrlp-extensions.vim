ctrlp-extensions.vim
====================

Extensions for ctrlp.vim

- cmdline : cmdline history
- yankring : yank history
- menu : extension selector menu

Demo
----

### menu

![](https://dl.dropboxusercontent.com/u/175488/Screenshots/github.com/ctrlp-extensions.vim/CtrlPMenu.gif)

Requirement
-----------

- [ctrlp.vim](https://github.com/ctrlpvim/ctrlp.vim)

Usage
-----

### `:CtrlPCmdline`
  Invoking CtrlP in [cmdline-history](http://vimdoc.sourceforge.net/htmldoc/cmdline.html#cmdline-history)
### `:CtrlPMenu`
  Invoking CtrlP in CtrlP extensions (including files, buffers, mrus,)
### `:CtrlPYankring`
  Invoking CtrlP in yank history

Cutomization
------------

### `g:ctrlp_yankring_disable`

Set 1 to disable yankring feature.

It is useful with [yankround.vim](https://github.com/LeafCage/yankround.vim) plugin.

### `g:ctrlp_yankring_limit`

Limit display item number to this value.

```vim
" default value
let g:ctrlp_yankring_limit = 100
```

### `g:ctrlp_yankring_minimum_chars`

The minimum type keys to start searching candidates

```vim
" default value
let g:ctrlp_yankring_minimum_chars = 2
```

License
-------

MIT License

Author
------

sgur <sgurrr+vim@gmail.com>
