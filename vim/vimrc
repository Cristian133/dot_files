"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Maintains:
"           Cristian Andrione
"           cristian.andrione@gmail.com
"
" Codebase:
"           Lars Moelleken
"           http://moelleken.org - lars@moelleken.org
"
" Version:
"           1.0 - 28/12/2019
"           1.1 - 26/01/2020
"           1.2 - 30/07/2020
"           1.3 - 23/12/2020
"           1.4 - 24/06/2023
"           1.5 - 15/12/2024 current
"
" Sections:
"           -> General
"           -> VIM user interface
"           -> Colors and Fonts
"           -> Visual
"           -> Parenthesis/bracket
"           -> Text, tab and indent related
"           -> Files, backups and undo
"           -> Helpers funtions
"           -> Editing mappings
"           -> Open specials files
"           -> Moving around windows and buffers
"           -> Move and copy lines or selected blocks
"           -> Blank space treatments
"           -> Status line
"           -> File types
"           -> Vimdiff
"           -> Vimgrep
"           -> Tags
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" This changes the values of a LOT of options, enabling features
" which are not Vi compatible but really nice.
set nocompatible

" Set the default shell
set shell=bash

" Disable unsafe commands
set secure

" Disable modelines as a security precaution
set modelines=0
set nomodeline

" Enable filetype detection.
filetype on

" Enable filetype-specific plugins
filetype plugin on

" Enable filetype-specific indenting
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread

" Change leader from backslash to comma
" That means all \x commands turn into ,x
let mapleader = ","
let g:mapleader = ","

" Sets how many lines of history VIM has to remember
set history=1000

" Tell us about changes.
set report=0

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Set lines to the cursor - when moving vertically using j/k or Up/Down
set so=1

" Show line numbers or current line number
" in combination with relativenumber
set number

" Command bar height
set cmdheight=1

" This makes vim act like all other editors, buffers can
" exist in the background without being in a window.
" http://items.sjbach.com/319/configuring-vim-right
set hidden

" Allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Automatically wrap left and righ.
set whichwrap=b,s,h,l,<,>,[,]

" Turn off the bell
set noerrorbells
set novisualbell

" Add extra margin to the left
set foldcolumn=0

" Ignore case when searching
set ignorecase

" Use intelligent case while searching.
" (If search string contains an upper case letter, disable ignorecase.)
set smartcase

" Also switch on highlighting the last used search pattern
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" For regular expressions turn magic on
set magic

" Highlight current line
set cursorline

" Split vertically to the right.
set splitright

" Split horizontally below.
set splitbelow

" Do not reset cursor to start of line when moving around.
set nostartofline

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Turn on color syntax highlight
syntax enable

try
    "let g:hybrid_custom_term_colors = 1
    " Remove this line if using the default palette.
    let g:hybrid_reduced_contrast = 1
	colorscheme hybrid
catch
endtry

set background=dark

" Set encoding
set encoding=utf8

" Try to detect file formats.
" Unix for new files and autodetect for the rest.
set fileformats=unix,dos,mac

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Visual
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => Parenthesis/bracket
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Show matching brackets when text indicator is over them.
set showmatch

" Include angle brackets in matching.
set matchpairs+=<:>

" How many tenths of a second to blink when matching brackets.
set mat=2

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Expand tabs to spaces.
set expandtab

" Be smart when using tabs.
set smarttab

" Linebreak on 79 characters
set linebreak
set textwidth=79

set autoindent "Auto indent
set smartindent "Smart indent
set wrap "Wrap lines

" Number of spaces to use for each step of indent.
set shiftwidth=4
set tabstop=4

" None word dividers
set isk+=_,$,@,%,#,-

" Invisible characters
set showbreak=↪\
set listchars=tab:→\ ,eol:↲,nbsp:␣,trail:•,extends:»,precedes:«,space:.

" Highlight conflict markers.
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set swapfile
set directory=~/.vim/swaps

set backup
set writebackup
set backupdir=~/.vim/backups

set undofile
set undodir=~/.vim/undo

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" =>  Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" leader keys
map <leader>1 :call ToggleHex()<CR>
map <leader>2 :call ToggleCol80()<CR>
map <leader>3 :call ToggleNumber()<CR>
map <leader>4 :call ToggleWrap()<CR>

" Yank to end of line
map Y y$

" files and buffers
map <F4> :buffers<CR>:buffer<Space>
map <F5> :Explore<CR>
map <F6> :Bclose<CR>

" syntax-check
map <F9> :w!<CR>:call Build()<CR>
imap <F9> <Esc>:w!<CR>:call Built()<CR>

" :W sudo saves the file
" (useful for handling the permission-denied error)
command W w !sudo tee % > /dev/null

" save a file as root (,W)
noremap <leader>W :w !sudo tee % > /dev/null<CR>

"historial de búsquedas
map <leader>s q/

"historial de Ex-commands
map <leader>x q:

"listado de registros
map <leader>r :registers<CR>

"listado de marcas
map <leader>m :marks<CR>

" historial de saltos
nmap <Leader>j :call GotoJump()<CR>

" Fast saving
map <leader>w :w!<cr>
" Fast quit
map <leader>q :q<cr>

nmap <leader>ñ :set list!<CR>

" gi moves to last insert mode (default)
" gI moves to last modification
nnoremap gI `.

" Map <Space> to / (search) and Ctrl-<Space> to ? (backwards search).
map <space> /
map <C-space> ?

" Show current file as HTML. (to paste into Keynote)
nmap <Leader>h :TOhtml<CR>:w<cr>:!open %<CR>:q<CR>

" Close the current buffer
map <leader>bd :Bclose<cr>

" Close all the buffers
map <leader>ba :bufdo bd<cr>

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Disable highlight when <leader><CR> is pressed
map <silent> <leader><CR> :noh<CR>

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Open specials files
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" open .vimrc
map <leader>e :e ~/.vimrc<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around windows, buffers and marks
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"marks
map <leader><up> ['
map <leader><down> ]'

" buffers
map <leader><right> :bnext<cr>
map <leader><left>  :bprevious<cr>

map <leader>h :bnext<cr>
map <leader>l :bprevious<cr>

" windows
map <C-up>    <C-W>k
map <C-down>  <C-W>j
map <C-left>  <C-W>h
map <C-right> <C-W>l

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Move and copy lines or selected blocks
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Move a line or select block of text using ALT+[Up-Down]
nnoremap <M-Down> :m .+1<CR>==
nnoremap <M-Up> :m .-2<CR>==
inoremap <M-Down> <Esc>:m .+1<CR>==gi
inoremap <M-Up> <Esc>:m .-2<CR>==gi
vnoremap <M-Down> :m '>+1<CR>gv=gv
vnoremap <M-Up> :m '<-2<CR>gv=gv

" Copy a line or select block of text using SHIFT+ALT+[Up-Down]
nnoremap <M-S-Down> :t .+0<CR>==
nnoremap <M-S-Up> :t .-1<CR>==
inoremap <M-S-Down> <Esc>:t .+0<CR>==gi
inoremap <M-S-Up> <Esc>:t .-1<CR>==gi
vnoremap <M-S-Down> :t '>+0<CR>gv=gv
vnoremap <M-S-Up> :t '<-1<CR>gv=gv

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => System pasteboard
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Yank and put system pasteboard with <Leader>y/p
nnoremap <silent> <leader>y "+yy
nnoremap <silent> <leader>Y "+y$
nnoremap <silent> <leader>p "+p

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Blank space treatments
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"Highlight spaces at the end of the line
if has('autocmd')
    highlight ExtraWhitespace ctermbg=1 guibg=red
    match ExtraWhitespace /\s\+$/
endif

" Strip trailing whitespace
map <F10> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>
imap <F10> <Esc>:let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Status line
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Always show the status line
set laststatus=2

" :help mode()
set statusline=
"set statusline+=%#DiffAdd#%{(mode()=='n')?'\ \ NORMAL\ ':''}
"set statusline+=%#DiffChange#%{(mode()=='i')?'\ \ INSERT\ ':''}
"set statusline+=%#DiffDelete#%{(mode()=='r')?'\ \ REPLACE\ ':''}
"set statusline+=%#Visual#%{(mode()=='v')?'\ \ VISUAL\ ':''}
"set statusline+=%#WildMenu#%{(mode()=='c')?'\ \ COMMAND-LINE\ ':''}
"set statusline+=%#Visual#%{(mode()=='cv')?'\ \ EX\ ':''}
set statusline+=%#CursorIM#             " colour
set statusline+=\ %n\                   " buffer number
set statusline+=%#Visual#               " colour
"set statusline+=%{&paste?'\ PASTE\ ':''}
"set statusline+=%{&spell?'\ SPELL\ ':''}
set statusline+=%#CursorIM#             "
set statusline+=%R                      " readonly flag
set statusline+=%M\ \                   " modified [+] flag
set statusline+=%#CursorLine#           " colour
set statusline+=\ %t\                   " short file name
set statusline+=%1*%{StatuslineGit()}%*
set statusline+=%=                      " right align
set statusline+=%#CursorLine#           " colour
set statusline+=\ %{strlen(&filetype)?&filetype:'none'}\     "filetype
set statusline+=%#CursorIM#             " colour
set statusline+=\ %3l:%-2c\             " line + column
set statusline+=%#CursorLine#           " colour
set statusline+=\ %3p%%\                " percentage

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" File types
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" automatic commands
if has("autocmd")
  " file type detection
  " FORTH
  au BufRead,BufNewFile  *.fth,*.FTH,*.fs,*.FS,*.ft,*.FT set filetype=forth

  " markdown
  au BufRead,BufNewFile *.md,*.markdown,*.ronn     set filetype=markdown

  au Filetype gitcommit                setlocal tw=68 spell fo+=t nosi
  au BufNewFile,BufRead COMMIT_EDITMSG setlocal tw=68 spell fo+=t nosi

  " allow tabs on makefiles
  au FileType make                   setlocal noexpandtab
  au FileType go                     setlocal noexpandtab

  " set makeprg(depends on filetype) if makefile is not exist
  if !filereadable('makefile') && !filereadable('Makefile')
    au FileType c                    setlocal makeprg=gcc\ %\ -o\ %<
    au FileType sh                   setlocal makeprg=bash\ -n\ %
  endif
endif

" automatic commands
if has("autocmd")
  " allow tabs on makefiles
  au FileType make setlocal noexpandtab
endif

" statusline color
function! ColourStatusLineFileType()
    filetype detect
    if &filetype == 'make'
        hi StatusLine ctermbg=red ctermfg=235
    else
        setlocal expandtab shiftwidth=4 tabstop=4
        hi StatusLine ctermbg=202 ctermfg=235
        hi StatusLineNC ctermbg=202 ctermfg=235
    endif
endfunction

au BufEnter * call ColourStatusLineFileType()

function! Build()
    filetype detect
    echo "filetype:" &filetype
    let name = expand("%:r")
    " LaTeX
    if &filetype == 'tex'
        execute :w!<CR>
        execute :!pdflatex %<CR>
    " C
    elseif &filetype == 'c'
        execute "! gcc % -o" name
        let res =
        execute "! ./".name
    " Shell
    elseif &filetype == 'sh'
        execute "! chmod +x %"
        execute "! ./%"
    " Ruby
    elseif &filetype == 'ruby'
        execute "! chmod +x %"
        execute "! ruby %"
    " Python
    elseif &filetype == 'python'
        execute "! chmod +x %"
        execute "! python3 %"
    " Rust
     elseif &filetype == 'rust'
        "execute "! cargo build"
        execute "! cargo run"
   else
        echo "No sabemos como procesar este tipo de archivo"
    endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Vimdiff
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Ignore whitespace in vimdiff.
if &diff
  set diffopt+=iwhite
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Vimgrep
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"TODO

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Tags
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"T para ir a tag
map T <C-]>

"<C-t> para volver del tag

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
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

" current buffer size
function! FileSize()
    let bytes = getfsize(expand("%:p"))
    if bytes <= 0
        return ""
    endif
    if bytes < 1024
        return bytes
    else
        return (bytes / 1024) . "K"
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

" hexadecimal
let s:activatehex = 0
function! ToggleHex()
    if s:activatehex == 0
        let s:activatehex = 1
        :%!xxd
    else
        let s:activatedhex = 0
        :%!xxd -r
    endif
endfunction

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

"Get git branch and status of edited file
function! GitBranch()
  return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! StatuslineGit()
  let l:branchname = GitBranch()
  return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
endfunction

" returns a string <branch/XX> where XX corresponds to the git status
" (for example "<master/ M>")
function CurrentGitStatus()
  let gitoutput = split(system('git status --porcelain -b '.shellescape(expand('%')).' 2>/dev/null'),'\n')
  if len(gitoutput) > 0
    let b:gitstatus = strpart(get(gitoutput,0,''),3) . '/' . strpart(get(gitoutput,1,'  '),0,2)
  else
    let b:gitstatus = ''
  endif
endfunc
autocmd BufEnter,BufWritePost * call CurrentGitStatus()

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

function Highlight_Statusline()
    hi User1 ctermfg=Yellow ctermbg=236 cterm=bold
endfunction

autocmd ColorScheme * call Highlight_Statusline()
autocmd BufEnter * call Highlight_Statusline()

function! WindowNumber()
    return tabpagewinnr(tabpagenr())
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
