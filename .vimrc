set relativenumber
set number
syntax on
imap jk <Esc>
imap kj <Esc>
set cursorline
set cursorcolumn
set tabstop=4
set nobackup
set incsearch
set ignorecase
set smartcase
set showcmd
set showmatch
set wildmenu
set wildmode=list:longest
runtime! ftplugin/man.vim
set autoindent
packadd! dracula
call plug#begin()

Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle'}
Plug 'vim-airline/vim-airline'
Plug 'https://github.com/tpope/vim-commentary'

call plug#end()

colorscheme dracula
"for nerdtree
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>
