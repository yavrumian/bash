set relativenumber
set number
syntax on
inoremap " ""<left>
inoremap ' ''<left>
inoremap ( ()<left>
set cursorline
set cursorcolumn
set tabstop=4
set nobackup
set ignorecase
set smartcase
set showcmd
set showmatch
set wildmenu
set wildmode=list:longest
runtime! ftplugin/man.vim
set smartindent
set autoindent 
set cindent
set indentexpr=
packadd! dracula
call plug#begin()

Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle'}
Plug 'vim-airline/vim-airline'

call plug#end()

colorscheme dracula
"for nerdtree
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

let g:user42 = 'vyavrumy'
let g:mail42 = 'vyavrumy@student.42yerevan.am'
