" save 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
"}}}1

function! SandJoin#wrapper#gJ(cmd) abort range
  let save_pat = get(b:, 'SandJoin_patterns', [])
  let b:SandJoin_patterns = [
        \ ['[^ \t\\]\zs\s\+', ' ', 'GLOBAL'],
        \ ["'^['. split(&commentstring, '%s')[0] .' \t]*'", '', '^top'],
        \ ]

  if get(g:SandJoin#patterns, &ft) isnot# 0
    let b:SandJoin_patterns = [ b:SandJoin_patterns, g:SandJoin#patterns[&ft] ]
  endif

  exe a:firstline ',' a:lastline 'SandJoin norm! gJ'

  if empty(save_pat)
    unlet b:SandJoin_patterns
  else
    let b:SandJoin_patterns = save_pat
  endif
endfunction

" restore 'cpoptions' {{{1
let &cpo = s:save_cpo
unlet s:save_cpo

" modeline {{{1
" vim: et ts=2 sts=2 sw=2 fdm=marker tw=79
