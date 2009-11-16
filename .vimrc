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

" Use smart indenting when starting a new line
set smartindent

" Don't use c style indenting
set nocindent

" Number of spaces in a tab
set tabstop=4

" Number of space for each indent
set shiftwidth=4


"""""" White space
autocmd BufWritePre * :%s/\s\+$//e


"""""" PHP stuff
" highlights interpolated variables in sql strings and does sql-syntax highlighting
autocmd FileType php let php_sql_query=1

" highlights html inside of php strings
autocmd FileType php let php_htmlInStrings=1

" automagically folds functions & methods
autocmd FileType php let php_folding=1

" make: % to check php syntax
set makeprg=php\ -l\ %
set errorformat=%m\ in\ %f\ on\ line\ %l


"""""" Key bindings
" Map upper-case W to lower-case W
cmap W w


""""""""""""" GUI stuff
colorscheme darkspectrum

set guioptions-=T

set gfn=DejaVu\ Sans\ Mono\ 8
