"""""" Syntax stuff
syntax enable
" Show matching parenthesis
set showmatch
" Show line numbers
set nu


"""""" Search
" Display the match for a search pattern when halfway typing it
set incsearch
" Ignore case while searching
set ignorecase


"""""" Indentation
" When moving to next line, autoident to same level
set autoindent

" Load file specific indenting pluging
filetype plugin indent on

" Expand tabs to spaces
set expandtab

" Insert spaces for tabs according to shiftwidth
set smarttab

" Use indent from current line when starting a new one
set autoindent

" Don't use c style indenting
set nocindent

" Number of spaces in a tab
set tabstop=4

" Number of space for each indent
set shiftwidth=4


"""""" White space
autocmd BufWritePre * :%s/\s\+$//e


"""""" PHP stuff
" highlights html inside of php strings
autocmd FileType php let php_htmlInStrings=1

" make: % to check php syntax
set makeprg=php\ -l\ %
set errorformat=%m\ in\ %f\ on\ line\ %l


"""""" Fix typos
cabbrev Wq wq
cabbrev WQ wq
cabbrev Q q
cabbrev W w
cabbrev E e


"""""" GUI stuff
colorscheme darkspectrum
set guioptions-=T
set gfn=DejaVu\ Sans\ Mono\ 8


"""""" Scroll with context
set scrolloff=3
set sidescrolloff=3


""""""""""""""""""""""""""""""""""
" autoreloading of vim config when saving it
autocmd! bufwritepost .vimrc source ~/.vimrc
