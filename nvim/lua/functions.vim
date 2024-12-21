"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Blank space treatments
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"Highlight spaces at the end of the line
if has('autocmd')
    highlight ExtraWhitespace ctermbg=1 guibg=red
    match ExtraWhitespace /\s\+$/
endif

" Strip trailing whitespace
" nmap <F10> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>
" imap <F10> <Esc>:let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Highlight Yank feature builtin nvim 0.5+
"       PR:https://github.com/neovim/neovim/pull/12279
"       Doc: https://neovim.io/doc/user/lua.html#vim.highlight
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank({higroup="IncSearch", timeout=700})
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" terminal
let g:term_buf = 0
let g:term_win = 0

function! Term_toggle(height)
    if win_gotoid(g:term_win)
        hide
    else
        botright new
        exec "resize " . a:height
        try
            exec "buffer " . g:term_buf
        catch
            call termopen($SHELL, {"detach": 0})
            let g:term_buf = bufnr("")
            set nonumber
        endtry
        startinsert!
        let g:term_win = win_getid()
    endif
endfunction

"Do not close window when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction

" highlight text from column 80
let s:activatedh = 0
function! ToggleCol80()
    if s:activatedh == 0
        let s:activatedh = 1
        match Search '\%80v.\+'
    else
        let s:activatedh = 0
        match none
    endif
endfunction

" number or relativenumber
function! ToggleNumber()
    if(&relativenumber == 1)
        set norelativenumber
        set number
    else
        set relativenumber
    endif
endfunc

"Toggle wrap - nowrap (líneas reales - líneas visibles)
let s:activatewrap = 0
function! ToggleWrap()
    if s:activatewrap == 0
        let s:activatewrap = 1
        set nowrap
    else
        let s:activatewrap = 0
        set wrap
    endif
endfunction

function! GotoJump()
    jumps
    let j = input("Please select your jump: ")
    if j != ''
        let pattern = '\v\c^\+'
        if j =~ pattern
            let j = substitute(j, pattern, '', 'g')
            execute "normal " . j . "\<c-i>"
        else
            execute "normal " . j . "\<c-o>"
        endif
    endif
endfunction

" Chat GPT version
function! Build()
    filetype detect
    echo "Filetype detected: " . &filetype

    " Variables locales
    let l:filename = expand("%:t")
    let l:name = fnamemodify(l:filename, ":r")

    " Comandos por tipo de archivo
    let l:commands = {
                \ 'tex':    printf("pdflatex %s", l:name),
                \ 'c':      [printf("gcc %% -o %s", l:name), printf("./%s", l:name)],
                \ 'sh':     [printf("chmod +x %%"), printf("./%%")],
                \ 'ruby':   [printf("chmod +x %%"), printf("ruby %%")],
                \ 'python': printf("python3 %%"),
                \ 'rust':   "cargo run",
                \ 'make':   "make",
                \ }

    " Procesar según el tipo de archivo
    if has_key(l:commands, &filetype)
        let l:cmd = l:commands[&filetype]
        if type(l:cmd) == type([]) " Si es una lista, ejecutar cada comando
            for cmd in l:cmd
                execute "!" . cmd
            endfor
        else
            execute "!" . l:cmd
        endif
    elseif l:filename == "Makefile"
        " Caso especial para Makefile
        execute "!make"
    else
        echo "Unsupported filetype: " . &filetype
    endif
endfunction

" function! Build()
"     filetype detect
"     echo "filetype:" &filetype
"     let name_ext = expand("%:t")
"     let name = fnamemodify(name_ext, ":r")
"     if &filetype == 'tex'
"         execute "! pdflatex " name
"     elseif &filetype == 'c'
"         execute "! gcc % -o" name
"         execute "! ./"name
"     elseif &filetype == 'sh'
"         execute "! chmod +x %"
"         execute "! ./%"
"     elseif &filetype == 'ruby'
"         execute "! chmod +x %"
"         execute "! ruby %"
"     elseif &filetype == 'python'
"         execute "! chmod +x %"
"         execute "! python3 %"
"      elseif &filetype == 'rust'
"         execute "! cargo run"
"     else
"         echo "We don't know how to process this type of file"
"     endif
" endfunction
"
function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("Ack \"" . l:pattern . "\" " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction
