" save 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
"}}}1

let s:pat_empty  = ['', '']
let s:pat_for_gJ = ['^[ \t\\]\+', '', '^top']

function! SandJoin#wrapper#gJ(cmd) abort range
  let save_pat = get(b:, 'SandJoin_patterns', s:pat_empty)
  call s:set_pat_for_gJ()
  call add(b:SandJoin_patterns, save_pat)

  exe a:firstline ',' a:lastline 'SandJoin norm! gJ'

  if save_pat is s:pat_empty
   unlet b:SandJoin_patterns
  else
   let b:SandJoin_patterns = save_pat
  endif
endfunction

function! s:set_pat_for_gJ() abort
  let pat = []
  call add(pat, s:pat_for_gJ)

  for l:key in ['_', &ft]
    let p = get(g:SandJoin#patterns, l:key)
    if empty(p) || p is s:pat_empty | continue | endif
    call add(pat, p)
  endfor

  let b:SandJoin_patterns = pat
endfunction

" restore 'cpoptions' {{{1
let &cpo = s:save_cpo
unlet s:save_cpo

" modeline {{{1
" vim: et ts=2 sts=2 sw=2 fdm=marker tw=79
