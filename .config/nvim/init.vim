" Neovim Configuration
" Modern Vim setup with enhanced features

" Load vim config as base
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

" Source the main vimrc
if filereadable(expand('~/.vimrc'))
    source ~/.vimrc
endif

" Neovim specific settings
if has('nvim')
    " Terminal settings
    tnoremap <Esc> <C-\><C-n>
    tnoremap <C-h> <C-\><C-n><C-w>h
    tnoremap <C-j> <C-\><C-n><C-w>j
    tnoremap <C-k> <C-\><C-n><C-w>k
    tnoremap <C-l> <C-\><C-n><C-w>l
    
    " Open terminal in split
    nnoremap <Leader>t :split<CR>:terminal<CR>
    nnoremap <Leader>vt :vsplit<CR>:terminal<CR>
    
    " Better terminal colors
    set termguicolors
    
    " Inccommand for live substitution preview
    set inccommand=split
    
    " Modern clipboard
    set clipboard+=unnamedplus
endif

" Plugin management with vim-plug (if available)
" Uncomment and run :PlugInstall to install plugins

"
" call plug#begin('~/.local/share/nvim/plugged')
" 
" " Essential plugins
" Plug 'tpope/vim-sensible'          " Sensible defaults
" Plug 'tpope/vim-surround'          " Surround text objects
" Plug 'tpope/vim-commentary'        " Easy commenting
" Plug 'tpope/vim-fugitive'          " Git integration
" 
" " File navigation
" Plug 'preservim/nerdtree'          " File tree
" Plug 'ctrlpvim/ctrlp.vim'          " Fuzzy file finder
" 
" " Appearance
" Plug 'vim-airline/vim-airline'     " Status line
" Plug 'vim-airline/vim-airline-themes'
" Plug 'morhetz/gruvbox'             " Color scheme
" 
" " Language support
" Plug 'neoclide/coc.nvim', {'branch': 'release'}  " LSP support
" Plug 'sheerun/vim-polyglot'        " Language pack
" 
" call plug#end()
"

" If you want to install vim-plug, run:
" curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
"     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

" Alternative: Use built-in package management
" mkdir -p ~/.local/share/nvim/site/pack/plugins/start
" cd ~/.local/share/nvim/site/pack/plugins/start
" git clone https://github.com/tpope/vim-sensible.git