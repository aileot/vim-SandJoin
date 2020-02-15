" ============================================================================
" Repo: kaile256/vim-SandJoin
" File: plugin/SandJoin.vim
" Author: kaile256
" License: MIT license {{{
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
" ============================================================================

if exists('g:loaded_SandJoin') | finish | endif
let g:loaded_SandJoin = 1

" save 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
"}}}

command! -bar -range -nargs=? SandJoin
      \ :call SandJoin#do(<q-args>, "<line1>", "<line2>")

nnoremap <silent> <Plug>(SandJoin-J) :SandJoin norm! J<cr>
xnoremap <silent> <Plug>(SandJoin-J) :SandJoin norm! J<cr>

if has('patch-7.4.156')
  nnoremap <silent> <Plug>(SandJoin-gJ) :call SandJoin#wrapper#gJ('norm! gJ')<cr>
  xnoremap <silent> <Plug>(SandJoin-gJ) :call SandJoin#wrapper#gJ('norm! gJ')<cr>
else
  nnoremap <silent> <Plug>(SandJoin-gJ) :SandJoin norm! gJ<cr>
  xnoremap <silent> <Plug>(SandJoin-gJ) :SandJoin norm! gJ<cr>
endif

if !get(g:, 'SandJoin#no_default_mappings', 0)
  nmap J <Plug>(SandJoin-J)
  xmap J <Plug>(SandJoin-J)
  nmap gJ <Plug>(SandJoin-gJ)
  xmap gJ <Plug>(SandJoin-gJ)
endif

" restore 'cpoptions' {{{1
let &cpo = s:save_cpo
unlet s:save_cpo

" modeline {{{1
" vim: expandtab tabstop=2 softtabstop=2 shiftwidth=2
" vim: foldmethod=marker textwidth=79
