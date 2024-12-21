if has('comments')
  setlocal comments=sr:(*,mb:*,ex:*)
  setlocal commentstring=(*%s*)
endif

" matchit.vim integration:
let b:match_ignorecase = 0
" `end` is ambiguous, so struct/sig only matches forward.
let b:match_words =
      \'\<\%(let\|local\)\>:\<in\>:\<end\>'
      \. ',\<\%(struct\|sig\)\>:\<end\>'

" a.vim integration
if exists('g:alternateExtensionsDict')
  let g:alternateExtensionsDict['sml'] = 'sig,smi'
  let g:alternateExtensionsDict['sig'] = 'sml'
  let g:alternateExtensionsDict['smi'] = 'sml'

  let g:alternateExtensionsDict['lex'] = 'grm,yacc'
  let g:alternateExtensionsDict['yacc'] = 'lex'
  let g:alternateExtensionsDict['grm'] = 'lex'
endif
