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

" `gJ` doesn't include white spaces and tabs though `J` ignore them to join
let g:SandJoin#patterns = get(g:, 'SandJoin#patterns', {
      \ '_': [
      \   ['[^ \t]\zs\s\+', ' ', 'GLOBAL'],
      \   ["'^['. split(&commentstring, '%s')[0] .' \t]*'", '', '^top'],
      \ ],
      \ 'sh': ['[\\ \t]*$', '', '^bottom'],
      \ 'vim': ['^[" \t\\]*', '', '^top'],
      \ })

" the lists corresponds to ["v", "'>"]; help at line()
let s:s_ranges_mod = {
      \ '^top':    [+1, 0],
      \ '^bottom': [0, -1],
      \ }

function! SandJoin#do(cmd, line1, line2) abort
  call SandJoin#substitute(a:line1, a:line2)
  call SandJoin#join(a:cmd)
endfunction

function! SandJoin#substitute(line1, line2) abort
  call s:set_range(a:line1, a:line2)
  let pat = s:set_s_pat()
  call s:s_in_range(pat)
endfunction

function! SandJoin#join(cmd, ...) abort
  " this function is available even when a:cmd is unrelated to 'J/gJ' inspite
  " of the name; the name only indicates the role in the standard usage of
  " SandJoin#do().

  if a:0 == 2
    call s:set_range(a:1, a:2)
  elseif a:0 > 0
    throw 'Invalid arguments: accepts either 0 or 2 arguments'
  endif

  " reset pos of cursor to the top in related range
  exe s:line1

  let cmd = a:cmd ==# '' ? 'norm! J' : a:cmd
  let cnt = s:line2 - s:line1
  while cnt
    " keep cursor on top of the range to join all into a line
    exe cmd
    let cnt -= 1
  endwhile
endfunction

function! s:set_range(line1, line2) abort "{{{1
  let s:line1 = a:line1
  let s:line2 = a:line1 == a:line2 ? a:line2 + 1 : a:line2
endfunction

function! s:set_s_pat() abort "{{{1
  let patterns = get(b:, 'SandJoin_patterns', g:SandJoin#patterns)
  let ret = get(patterns, &ft, ['', ''])

  if get(patterns, '_') isnot# 0
    return [ g:SandJoin#patterns['_'], ret ]
  endif

  return ret
endfunction

function! s:s_in_range(s_pat) abort "{{{1
  if type(a:s_pat[0]) == type([])
    call s:s_in_loop(a:s_pat)
    return
  endif

  let label = get(a:s_pat, 2)
  let diff  = get(s:s_ranges_mod, tolower(label), [0, 0])

  let range = (s:line1 + diff[0]) .','. (s:line2 + diff[1])
  call s:s_as_patterns(a:s_pat, range)
endfunction

function! s:s_in_loop(patterns) abort
  for pat in a:patterns
    call s:s_in_range(pat)
  endfor
endfunction

function! s:s_as_patterns(s_pat, range) abort
  let flags = get(a:s_pat, 2) =~# '\u' ? 'g' : ''
  let before = s:eval_pat(a:s_pat[0])
  let after  = s:eval_pat(a:s_pat[1])
  exe 'silent! keeppatterns' a:range .'s/'. before .'/'. after .'/'. flags
endfunction

function! s:eval_pat(pat) abort
  try
    let ret = eval(a:pat)
    return type(ret) == type('') ? ret : string(ret)
  catch
    return a:pat
  endtry
endfunction

" restore 'cpoptions' {{{1
let &cpo = s:save_cpo
unlet s:save_cpo

" modeline {{{1
" vim: et ts=2 sts=2 sw=2 fdm=marker tw=79
