" ============================================================================
" Repo: kaile256/vim-SandJoin
" File: autoload/SandJoin.vim
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

" save 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
"}}}1

let g:SandJoin#patterns = get(g:, 'SandJoin#patterns', {
      \ 'sh': [
      \   ['\\s*$', '', '^bottom'],
      \   ['^[# \t]*', '', '^top'],
      \   ],
      \ 'vim': ['^[" \t\\]*', '', '^top'],
      \ })

" [normal, visual start, visual end]
let s:s_ranges_mod = {
      \ 'default': [0,  0, 0],
      \ '^top':    [+1, +1 ,0],
      \ '^bottom': [0,  0, -1],
      \ }

function! SandJoin#do(line1, ...) abort
  let s:line1 = eval(a:line1)
  let s:line2 = a:0 > 0 ? eval(a:1) : s:line1 + 1
  let s:line2 = s:line1 == s:line2 ? s:line2 + 1 : s:line2

  let s_pat = get(g:SandJoin#patterns, &ft, ['', ''])

  if type(s_pat[0]) == type([])
    call s:s_in_loop(s_pat)
  else
    call s:s_in_range(s_pat)
  endif

  call s:join_in_range()
endfunction

function! s:s_in_loop(s_pat) abort
  for pat in a:s_pat
    call s:s_in_range(pat)
  endfor
endfunction

function! s:s_in_range(s_pat) abort
  let mod = get(a:s_pat, 2, 'default')
  let s_range = s:s_ranges_mod[mod]

  let range = (s:line1 + s_range[1]) .','. (s:line2 + s_range[2])

  call s:s_as_patterns(a:s_pat, range)
endfunction

function! s:s_as_patterns(s_pat, range) abort
  let flag  = 'e'
  let flag .= a:s_pat[2] =~# '\u' ? 'g' : ''
  exe 'keeppatterns' a:range .'s/'. a:s_pat[0] .'/'. a:s_pat[1] .'/'. flag
endfunction

function! s:join_in_range() abort "{{{1
  " reset pos of cursor to the top in related range
  exe s:line1

  let cnt = s:line2 - s:line1
  while cnt
    norm! J
    let cnt -= 1
  endwhile
endfunction

" restore 'cpoptions' {{{1
let &cpo = s:save_cpo
unlet s:save_cpo

" modeline {{{1
" vim: et ts=2 sts=2 sw=2 fdm=marker tw=79
