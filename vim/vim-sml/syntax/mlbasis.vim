if version < 600
  syntax clear
elseif exists('b:current_syntax')
  finish
endif

let b:current_syntax = 'mlbasis'

syn keyword mlbasisKeyword and ann basis functor end in local let open structure signature
hi link mlbasisKeyword Keyword

syn match mlbasisPath ".\+\.\(fun\|mlb\|sig\|sml\)" contains=mlbasisPathMapping
hi link mlbasisPath Identifier

syn match mlbasisPathMapping "\$([A-Za-z_]\+)"
hi link mlbasisPathMapping Preproc

syn keyword mlbasisTodo contained TODO FIXME XXX
hi link mlbasisTodo Todo

syn region mlbasisComment start="(\*" end="\*)" contains=mlbasisComment,mlbasisTodo
hi link mlbasisComment Comment
