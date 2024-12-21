if version < 600
  syntax clear
elseif exists('b:current_syntax')
  finish
endif

let b:current_syntax = 'smackspec'

syn match smackspecKey "^\s*[^:]\+\(:\)\@="
hi link smackspecKey Identifier

syn match smackspecVersion "[0-9]\+\(\.[0-9]\+\)*"
hi link smackspecVersion Number
