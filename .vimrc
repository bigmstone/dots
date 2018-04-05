set nocompatible
filetype off

set shell=/bin/bash

set mouse=a
set ttymouse=sgr
set clipboard=unnamed

set conceallevel=0

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'

Bundle 'tpope/vim-fugitive'
Bundle 'tomasr/molokai'
Bundle 'tpope/vim-repeat'
Bundle 'kien/ctrlp.vim'
Bundle 'plasticboy/vim-markdown'
Bundle 'sjl/gundo.vim'
"Bundle 'Valloric/YouCompleteMe'
Bundle 'maralla/completor.vim'
Bundle 'jelera/vim-javascript-syntax'
Bundle 'w0rp/ale'
Bundle 'wincent/command-t'
Bundle 'altercation/vim-colors-solarized'
"Bundle 'jnurmine/Zenburn'
Bundle 'tpope/vim-surround'
Bundle 'airblade/vim-gitgutter'
Bundle 'danilo-augusto/vim-afterglow'
Bundle 'wincent/Command-T'
Bundle 'Lokaltog/vim-distinguished'
Bundle 'fenetikm/falcon'
Bundle 'bling/vim-airline'
Bundle 'scrooloose/nerdtree'
Bundle 'Xuyuanp/nerdtree-git-plugin'
Bundle 'majutsushi/tagbar'
Bundle 'fatih/vim-go'
Bundle 'jmcantrell/vim-virtualenv'
Bundle 'davidhalter/jedi-vim'
Bundle 'mileszs/ack.vim'
Bundle 'rust-lang/rust.vim'
Bundle 'Yggdroot/indentLine'
Bundle 'mxw/vim-jsx'
Bundle 'chase/vim-ansible-yaml'
Bundle 'scrooloose/nerdcommenter'
Bundle 'mattn/webapi-vim'
Bundle 'mattn/gist-vim'
Bundle 'tpope/vim-dadbod'

call vundle#end()

let g:virtualenv_directory = '.'

filetype plugin indent on

let g:ale_sign_column_always = 1
set statusline+=%#warningmsg#
set statusline+=%*

"set statusline+=%{SyntasticStatuslineFlag()}
"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0
"let g:syntastic_go_checkers = ['gometalinter']
"let g:syntastic_javascript_checkers = ['eslint']

let g:ackprg = 'rg --vimgrep'

syntax on
filetype on
filetype plugin indent on
set number
set background=dark
set title
set wildmenu
set wildmode=full
set t_Co=256

set noerrorbells
set vb t_vb=

autocmd VimEnter * Tagbar
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

set cursorline
set ruler
set nostartofline
set virtualedit=block
set scrolloff=3
set backspace=2
set showmatch
"set wrap
"set textwidth=79
set colorcolumn=80
set linebreak
set autoindent
set smartindent
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set shiftround
set formatoptions=tcroql
set autowriteall
set noautoread
set modeline
set modelines=5
set ls=2
set vb t_vb=
set showcmd
set report=0
set shortmess+=a
set ruler
set laststatus=2
set ignorecase
set smartcase
set hlsearch
set incsearch


"colorscheme distinguished
"colorscheme solarized
"colorscheme afterglow
colorscheme falcon

hi Normal ctermbg=none
highlight Normal ctermbg=NONE
highlight nonText ctermbg=NONE


let NERDTreeQuitOnOpen = 1
map <silent> <C-n> :NERDTreeToggl<CR>


let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
    \ }

if &term =~ '^screen'
    " tmux will send xterm-style keys when its xterm-keys option is on
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
endif

let g:jsx_ext_required = 0 " Allow JSX in normal JS files


autocmd FileType tf setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType html setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType yaml setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType yml setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType javascript setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType javascript setlocal colorcolumn=100
autocmd FileType ruby setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType python setlocal omnifunc=jedi#completions
autocmd FileType python setlocal colorcolumn=80
autocmd FileType go setlocal colorcolumn=100

set spell
set spelllang=en_us

hi clear SpellBad
hi SpellBad cterm=underline

autocmd filetype crontab setlocal nobackup nowritebackup
