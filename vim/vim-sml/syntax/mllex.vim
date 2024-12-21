if version < 600
  syntax clear
elseif exists('b:current_syntax')
  finish
endif

syn region mllexComment start="(\*" end="\*)" contains=mllexComment,mllexTodo
syn keyword mllexTodo contained TODO FIXME XXX

hi link mllexComment Comment
hi link mllexSeparator Comment
hi link mllexSemicolon Operator
hi link mllexTodo Todo

syn include @mllexExpr syntax/sml.vim

syn region mllexDeclarations start="^\(\h\+\s\|%{\)" end="^\ze%%\s*$" skipempty skipwhite nextgroup=mllexDefinitions contains=@mllexExpr

syn match mllexPattern '\(\S\|\\ \)\+' contained contains=mllexPatternCharClass,mllexPatternMetaChar,mllexPatternString,mllexPatternId nextgroup=mllexRuleAssignment skipwhite
syn match mllexPatternCharClass '\[[^\]]*\]' contained
syn match mllexPatternId "{[A-Za-z0-9][A-Za-z0-9_']*}" contained
syn match mllexPatternMetaChar '\([~$\^.*+?|()]\|\\["~\-$\^.*+?|()\\a-z]\)' contained
syn region mllexPatternString start='"' end='"' skip="\\\"" contained

hi link mllexPatternCharClass Special
hi link mllexPatternId Identifier
hi link mllexPatternMetaChar Operator
hi link mllexPatternString String

syn region mllexDefinitions matchgroup=mllexSeparator	start="^%%\s*$" end="^%\ze%\s*$" contains=mllexDefinition,mllexComment skipempty skipwhite nextgroup=mllexRules keepend
syn region mllexDefinition start='\((\*\)\@!' matchgroup=mllexSemicolon end=';' contained contains=mllexDefinitionCommand,mllexDefinitionPatternId keepend

syn match mllexDefinitionCommand '^%[^%].\+' contains=mllexDefinitionStates,mllexDefinitionNulladicCommand,mllexDefinitionIdCommand,mllexDefinitionExprCommand
syn match mllexDefinitionStates '^%s\>' contained nextgroup=mllexDefinitionState skipwhite
syn match mllexDefinitionState "\<[A-Za-z0-9_']\+" contained nextgroup=mllexDefinitionState skipwhite
syn match mllexDefinitionNulladicCommand '^%\(reject\|count\|full\)\>' contained
syn match mllexDefinitionIdCommand '^%\(structure\)\>' contained nextgroup=mllexDefinitionId skipwhite
syn match mllexDefinitionId "\(\<[A-Za-z][A-Za-z0-9_']*\|[-*!%&$#+/:<=>?@\\~`^|]\+\)" contained
syn match mllexDefinitionExprCommand '^%\(header\|arg\)\>' contained nextgroup=@mllexExpr skipwhite
syn match mllexDefinitionPatternId "\<[A-Za-z][A-Za-z0-9_']\+" contained nextgroup=mllexDefinitionPatternAssignment skipwhite
syn match mllexDefinitionPatternAssignment '=\s*' contained nextgroup=mllexPattern skipwhite

hi link mllexDefinitionPatternId Identifier
hi link mllexDefinitionNulladicCommand Preproc
hi link mllexDefinitionExprCommand Preproc
hi link mllexDefinitionStates Preproc
hi link mllexDefinitionIdCommand Preproc
hi link mllexDefinitionId Identifier
hi link mllexDefinitionState Identifier
hi link mllexDefinitionPatternAssignment Operator
hi link mllexDefinitionPattern String

syn region mllexRules matchgroup=mllexSeparator start="%\s*$"me=e-1 end="\%$" contained contains=mllexRule,mllexComment
syn region mllexRule start='^\s*\(["{]\|\\\?[a-z]\|\.\|)\(\*\)\@!\)' end=';\s*$' matchgroup=mllexSemicolon contained contains=mllexRuleStates,mllexPattern keepend

syn region mllexRuleStates matchgroup=Operator start='<' end='>' contains=mllexRuleState contained nextgroup=mllexPattern skipwhite
syn match mllexRuleState "\<[A-Za-z][A-Za-z0-9_']*" contained
syn match mllexRuleAssignment '=>' contained nextgroup=@mllexExpr skipwhite

hi link mllexRuleState Identifier
hi link mllexRuleAssignment Operator

let b:current_syntax = 'mllex'
