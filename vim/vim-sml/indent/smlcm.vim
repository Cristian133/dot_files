if exists('b:did_indent')
  finish
end

let b:did_indent = 1

function! SMLCMIndent(lnum)
  let line_no = prevnonblank(a:lnum - 1)
  " Never indent first line
  if line_no == 0
    return 0
  end

  let line_contents = getline(line_no)
  let line_start    = match(line_contents, '\S')

  if match(line_contents, '\c\<\(library\|group\|is\)\>\s*$') != -1
    return line_start + &sw
  end

  return line_start
endf

setlocal indentexpr=SMLCMIndent(v:lnum)
