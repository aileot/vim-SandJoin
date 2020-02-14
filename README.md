# vim-SandJoin

Try missing `J` especially for `\` in Vimscript and Shellscript

Ignore leading tabs and white spaces on `gJ`

## Installation

Install the plugin using your favorite package manager

### For dein.vim

```vim
call dein#add('kaile256/vim-SandJoin')
```

## Usage

This plugin makes a set of mappings to `J` and `gJ` unless
`g:SandJoin#no_default_mappings` is set to `1`.

```vim
" default
nmap J  <Plug>(SandJoin-J)
xmap J  <Plug>(SandJoin-J)
nmap gJ <Plug>(SandJoin-gJ)
xmap gJ <Plug>(SandJoin-gJ)
```

### Usage of `g:SandJoin#patterns`

```vim
" default
let g:SandJoin#patterns = {
      \ '_': ["'^['. matchstr(&commentstring, '.*\ze%s') .' \t]*'", '', '^top'],
      \ 'sh': ['[\\ \t]*$', '', '^bottom'],
      \ 'vim': ['^[" \t\\]*', '', '^top'],
      \ }
```

The variable, `g:SandJoin#patterns`, is internally used in `SandJoin#substitute()`.

1. To apply patterns to every filetypes, use `'_'` as a key.

1. The values should be a list in this order, `["before", "after", "label"]`.

   1. Both `"before"` and `"after"` are used as `s/"before"/"after"`.
      They will be respectively evaluated if possible.

   1. The third value, `"label"`, should be one of `['^top', '^bottom', 'default']`.
      Set `"label"` in _upper_ case to apply patterns with a flag, `g`.

   1. Lists could be nested;
      more than two patterns are available for each filetypes.
