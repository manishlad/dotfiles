"
" Enable Pathogen plugin manager
"
execute pathogen#infect()
call pathogen#helptags()

"
" General Settings
"
let mapleader="\,"        " Leader is comma

set nocompatible          " Enable all the fancy features
set term=xterm            " Terminal type
set background=dark       " Optimise font colours for dark background
set mouse=a               " Enable mouse usage (all modes) in terminals
set cursorline            " Highlight the current line
set ruler                 " Show line and column number
set showcmd               " Show (partial) command in status line.
set wildmenu              " Visual autocomplete for command menu
set hidden                " Hide buffers when they are abandoned
" set spell spelllang=en_gb " Spell checking

" Jump directly to the last position when reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif

"
" Searching
"
set showmatch   " Show matching brackets
set ignorecase  " Do case insensitive matching
set smartcase   " Do smart case matching
set incsearch   " Incremental search
set hlsearch    " Highlight all matches

nnoremap <leader><space> :nohlsearch<CR> " Turn off current search highlights

"
" Screen Management
"
nnoremap <leader>s :mksession<CR>  " Save session
nnoremap <leader>S :mksession!<CR> " Overwrite saved session

autocmd vimenter * NERDTree                " Automatically start NERDTree 
map <Leader>n <plug>NERDTreeTabsToggle<CR> " ,n toggles NERDTree

" Toggle full buffer height
map <C-J> <C-W>j<C-W>_
map <C-K> <C-W>k<C-W>_

" Fast window resizing with +/_ keys (horizontal); =/- keys (vertical)
map + <C-W>+
map _ <C-W>-
map = <c-w>>
map - <c-w><


"
" Programming Settings
"
syntax on  " Enable syntax highlighting
set number " Line numbering. Disable with "set nonumber" 


" set autowrite " Automatically save before commands like :next and :make

" Toggle line numbers and fold column for easy copying:
" nnoremap <F2> :set nonumber!<CR>:set foldcolumn=0<CR>


" Set the working directory to be the same as the buffer currently being edited
" This messes with cscope so is disabled here
" set autochdir

"
" Indentation
"
filetype plugin indent on " Load indentation rules based on detected filetype

set backspace=indent,eol,start " Allow backspace over autoindent and linebreaks
set pastetoggle=<F10>          " Allow pasting without autoindenting

set tabstop=4     " Number of spaces that a tab represents
set shiftwidth=4  " Number of spaces to use for each step of (auto)indent
set softtabstop=4 " Number of spaces a tab counts for
set smarttab      " Indent by shiftwidth when tabbing at start of line
set expandtab     " Spaces instead of tabs (CTRL-V<Tab> to insert a real tab)
set autoindent    " Copy indent from current line when starting a new line

