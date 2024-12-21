syn region smlcmComment start="(\*" end="\*)" contains=smlcmComment,smlcmTodo
hi link smlcmComment Comment

syn keyword smlcmTodo contained TODO FIXME XXX
hi link smlcmTodo Todo

syn match smlcmKeyword '\c\<\(group\|library\|is\|signature\|structure\|functor\|bind\|anchor\|value\)\>'
hi link smlcmKeyword Keyword

syn match smlcmAnchor "^\s*\zs\$[^/]*"
hi link smlcmAnchor Identifier

syn match smlcmPreproc '^\s*\zs#\(if\|else\|elif\|endif\)\ze\(\s\|$\)'
hi link smlcmPreproc Preproc

" TODO Highlight conditional compilation language
