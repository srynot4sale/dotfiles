" Inspiration
" - http://github.com/nvie/vimrc/blob/master/vimrc


"""""" Generics
set nocompatible
let mapleader=","               " Change mapleader from \ to ,
set hidden                      " When changing buffers, do not close (forcing a save) but hide
set nobackup                    " Don't create backup files


"""""" Syntax stuff
syntax enable
set showmatch                   " Show matching parenthesis
set nu                          " Show line numbers


"""""" Search
set incsearch                   " Display the match for a search pattern when halfway typing it
set ignorecase                  " Ignore case while searching
set hlsearch                    " Highlight search terms


"""""" Indentation
set autoindent                  " When moving to next line, autoident to same level
filetype plugin indent on       " Load file specific indenting pluging
set expandtab                   " Expand tabs to spaces
set smarttab                    " Insert spaces for tabs according to shiftwidth
set autoindent                  " Use indent from current line when starting a new one
set nocindent                   " Don't use c style indenting
set tabstop=4                   " Number of spaces in a tab
set shiftwidth=4                " Number of space for each indent
set shiftround                  " Use multiple of shiftwidth when indenting with < and >
set copyindent                  " Copy the previous indentation on autoindenting


"""""" White space
" Highlight whitespace at the end of lines
au InsertEnter * match Error /\s\+\%#\@<!$/
au InsertLeave * match Error /\s\+$/


"""""" Editing
set backspace=indent,eol,start
set list                        " Highlight invisible characters
set listchars=extends:#         " Display a # at the end of wrapping lines
" Highlight the line the cursor is on in the current window only
autocmd WinEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline


"""""" Fancy statusbar (from http://gist.github.com/187825)
set laststatus=2                " Always show the last status
set statusline=
set statusline+=%f "path to the file in the buffer, relative to current directory
set statusline+=\ %h%1*%m%r%w%0* " flag
set statusline+=\ [%{strlen(&ft)?&ft:'none'}, " filetype
set statusline+=%{&encoding}, " encoding
set statusline+=%{&fileformat}] " file format
set statusline+=\ CWD:%r%{getcwd()}%h
set statusline+=\ Line:%l/%L


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
cabbrev Bw bw
cabbrev BW bw
cabbrev bW bw
cabbrev Bn bn
cabbrev BN bn
cabbrev bN bn
cabbrev Bp bp
cabbrev BP bp
cabbrev bP bp
cabbrev Qall qall
" Disable Shift Enter due to fat fingers
map <S-CR> <Nop>


"""""" Keyboard remapping
" Make ; another : - no more shift needed!
nnoremap ; :
" Disable : to force me to change my behaviour
nnoremap : <nop>
" Set ,/ to hid search hilights
nmap <silent> ,/ ;nohlsearch<CR>
" Make arrow keys useful again
map <down> <ESC>;bn<RETURN>
map <up> <ESC>;bp<RETURN>
map <left> <ESC><C-W><left>
map <right> <ESC><C-W><right>


"""""" GUI stuff
if &t_Co >= 256 || has("gui_running")
   colorscheme mustang          " If gvim, or terminal has 256+ colors
endif

if has("gui_running")
    set guioptions-=T
    set gfn=DejaVu\ Sans\ Mono\ 8
endif

au! GuiEnter * set vb t_vb=     " Disable the visual bell in gvim


"""""" Terminal stuff
set title                       " Change terminal's title
set visualbell                  " No bell
set noerrorbells                " No bell


"""""" Scroll with context
set scrolloff=3
set sidescrolloff=3


""""""""""""""""""""""""""""""""""
" autoreloading of vim config when saving it
autocmd! bufwritepost .vimrc source ~/.vimrc
