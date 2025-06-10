" Enhanced Vim Configuration

" Basic settings
set nocompatible              " Disable vi compatibility
filetype plugin indent on     " Enable file type detection
syntax enable                 " Enable syntax highlighting

" Display settings
set number                    " Show line numbers
set relativenumber            " Show relative line numbers
set ruler                     " Show cursor position
set showcmd                   " Show command in status line
set showmode                  " Show current mode
set laststatus=2              " Always show status line
set cursorline                " Highlight current line
set colorcolumn=80            " Highlight column 80
set scrolloff=3               " Keep 3 lines visible above/below cursor
set sidescrolloff=5           " Keep 5 characters visible left/right of cursor

" Search settings
set hlsearch                  " Highlight search results
set incsearch                 " Incremental search
set ignorecase                " Case insensitive search
set smartcase                 " Case sensitive if uppercase present

" Indentation
set tabstop=4                 " Tab width
set shiftwidth=4              " Indent width
set softtabstop=4             " Soft tab width
set expandtab                 " Use spaces instead of tabs
set smartindent               " Smart indentation
set autoindent                " Auto indentation

" Text editing
set backspace=indent,eol,start " Better backspace behavior
set wrap                      " Enable line wrapping
set linebreak                 " Break lines at word boundaries
set textwidth=0               " Disable automatic line breaking
set formatoptions-=t          " Don't auto-wrap text

" File handling
set autoread                  " Auto-reload files changed outside vim
set hidden                    " Allow switching buffers without saving
set encoding=utf-8            " Use UTF-8 encoding
set fileencoding=utf-8        " Save files in UTF-8

" Backup and swap files
set nobackup                  " Disable backup files
set nowritebackup             " Disable backup before writing
set noswapfile                " Disable swap files
set undofile                  " Enable persistent undo
set undodir=~/.vim/undo       " Undo file directory

" Create undo directory if it doesn't exist
if !isdirectory($HOME.'/.vim/undo')
    call mkdir($HOME.'/.vim/undo', 'p')
endif

" Mouse and clipboard
set mouse=a                   " Enable mouse support
set clipboard=unnamedplus     " Use system clipboard

" Visual settings
set showmatch                 " Show matching brackets
set matchtime=2               " Blink time for matching brackets
set wildmenu                  " Enhanced command completion
set wildmode=longest:full,full " Command completion mode
set completeopt=menuone,longest " Completion options

" Color scheme
if has('termguicolors')
    set termguicolors
endif
colorscheme desert
set background=dark

" Status line
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}

" Key mappings
let mapleader = ','

" Quick save and quit
nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :q<CR>
nnoremap <Leader>x :x<CR>

" Clear search highlighting
nnoremap <Leader>/ :nohlsearch<CR>

" Better navigation
nnoremap j gj
nnoremap k gk
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Tab navigation
nnoremap <Leader>tn :tabnew<CR>
nnoremap <Leader>tc :tabclose<CR>
nnoremap <Leader>th :tabprev<CR>
nnoremap <Leader>tl :tabnext<CR>

" Buffer navigation
nnoremap <Leader>bn :bnext<CR>
nnoremap <Leader>bp :bprev<CR>
nnoremap <Leader>bd :bdelete<CR>

" Toggle line numbers
nnoremap <Leader>n :set number!<CR>

" Toggle paste mode
nnoremap <Leader>p :set paste!<CR>

" Indentation shortcuts
nnoremap <Tab> >>
nnoremap <S-Tab> <<
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

" Quick edit vimrc
nnoremap <Leader>ev :tabnew ~/.vimrc<CR>
nnoremap <Leader>sv :source ~/.vimrc<CR>

" Auto-commands
if has('autocmd')
    " Remove trailing whitespace on save
    autocmd BufWritePre * :%s/\s\+$//e
    
    " Return to last edit position when opening files
    autocmd BufReadPost *
         \ if line("'\"") > 0 && line("'\"") <= line("$") |
         \   exe "normal! g`\"" |
         \ endif
    
    " Auto-resize splits when the window is resized
    autocmd VimResized * wincmd =
    
    " File type specific settings
    autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4
    autocmd FileType javascript setlocal tabstop=2 shiftwidth=2 softtabstop=2
    autocmd FileType html setlocal tabstop=2 shiftwidth=2 softtabstop=2
    autocmd FileType css setlocal tabstop=2 shiftwidth=2 softtabstop=2
    autocmd FileType yaml setlocal tabstop=2 shiftwidth=2 softtabstop=2
    autocmd FileType json setlocal tabstop=2 shiftwidth=2 softtabstop=2
endif

" Performance optimizations
set lazyredraw                " Don't redraw during macros
set ttyfast                   " Fast terminal connection
set synmaxcol=200             " Limit syntax highlighting to 200 columns

" Search improvements
set gdefault                  " Add 'g' flag to search/replace by default

" Folding
set foldmethod=indent         " Fold based on indentation
set foldlevelstart=10         " Open most folds by default
set foldnestmax=10            " Maximum fold nesting

" Better split behavior
set splitbelow                " Horizontal splits open below
set splitright                " Vertical splits open to the right

" Command history
set history=1000              " Increase command history

" Wildmenu ignore
set wildignore=*.o,*.obj,*