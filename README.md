# vim-SandJoin

For `J`, join lines without left-behind `\` in Vimscript and Shellscript

For `gJ`, join lines without leading tabs and white spaces

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
      \ '_': [
      \   ['[^ \t]\zs\s\+', ' ', 'GLOBAL'],
      \   ["'^['. split(&commentstring, '%s')[0] .' \t]*'", '', '^top'],
      \ ],
      \ 'sh': ['[\\ \t]*$', '', '^bottom'],
      \ 'vim': ['^[" \t\\]*', '', '^top'],
      \ }
```

The variable, `g:SandJoin#patterns`, is internally used in `SandJoin#substitute()`.

1. To apply patterns to every filetypes, use `'_'` as a key.

1. The values should be a list in this order,
   `["before", "after", "label"(optional)]`.

   1. Lists can be nested;
      more than two patterns are applicable for each filetypes.

   1. Both `"before"` and `"after"` are used as `:s/"before"/"after"`.
      They will be respectively evaluated if possible.

   1. The third value, `"label"`, can be
      one of `'^top'`, `'^bottom'` and `'GLOBAL'`

      1. The values, `'^top'` and `'^bottom'`, means
         `:s` except top/bottom line in the range.
      1. To `:s` with `g` flag, set `"label"` in **upper** case like `'^TOP'`;
         if you want to `:s` all the lines in the range,
         use `'GLOBAL'` in **upper** case.
