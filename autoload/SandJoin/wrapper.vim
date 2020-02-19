" save 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
"}}}1

function! SandJoin#wrapper#gJ(cmd) abort range
  let b:SandJoin_patterns = [
        \ ['[^ \t\\]\zs\s\+', ' ', 'GLOBAL'],
        \ ["'^['. split(&commentstring, '%s')[0] .' \t]*'", '', '^top'],
        \ ]

  if get(g:SandJoin#patterns, &ft) isnot# 0
    let b:SandJoin_patterns = [ b:SandJoin_patterns, g:SandJoin#patterns[&ft] ]
  endif

  exe a:firstline ',' a:lastline 'SandJoin norm! gJ'

  unlet b:SandJoin_patterns
endfunction

" restore 'cpoptions' {{{1
let &cpo = s:save_cpo
unlet s:save_cpo

" modeline {{{1
" vim: et ts=2 sts=2 sw=2 fdm=marker tw=79
