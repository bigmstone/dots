set nocompatible
filetype off

" Vundle for life
set rtp+=~/.vim/bundle/Vundle.vim
set rtp+=/usr/local/opt/fzf
call vundle#begin()
Plugin 'gmarik/Vundle.vim'

Bundle 'vim-scripts/mru.vim'
Bundle 'tpope/vim-commentary'
Bundle 'terryma/vim-expand-region'
Bundle 'terryma/vim-multiple-cursors'
Bundle 'maxbrunsfeld/vim-yankstack'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-repeat'
Bundle 'moll/vim-node'
Bundle 'ycm-core/YouCompleteMe'
Bundle 'racer-rust/vim-racer'
Bundle 'w0rp/ale'
Bundle 'morhetz/gruvbox'
Bundle 'tpope/vim-surround'
Bundle 'airblade/vim-gitgutter'
Bundle 'danilo-augusto/vim-afterglow'
Bundle 'wincent/Command-T'
Bundle 'itchyny/lightline.vim'
Bundle 'scrooloose/nerdtree'
Bundle 'Xuyuanp/nerdtree-git-plugin'
Bundle 'majutsushi/tagbar'
Bundle 'tmhedberg/matchit'
Bundle 'mileszs/ack.vim'
Bundle 'rust-lang/rust.vim'
Bundle 'Yggdroot/indentLine'
Bundle 'junegunn/goyo.vim'
Bundle 'junegunn/limelight.vim'
Bundle 'elzr/vim-json'
Bundle 'dominikduda/vim_current_word'
Bundle 'tikhomirov/vim-glsl'
call vundle#end()

" General Stuffs
set shell=/bin/bash
set mouse=a
set ttymouse=sgr
set clipboard=unnamed
set number
set background=dark
set title
set wildmenu " Only the wildest of menus for me...
set wildmode=full
set t_Co=256
set noerrorbells
set vb t_vb= " WTAF is this?
set cursorline
set nostartofline
set virtualedit=block
set scrolloff=3
set backspace=2
set showmatch
set textwidth=80
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
set showcmd
set report=0
set shortmess+=a
set ruler
set laststatus=2
set ignorecase
set smartcase
set hlsearch
set incsearch
set spell
set spelllang=en_us
syntax on
silent! colorscheme gruvbox
hi Normal ctermbg=none
highlight Normal ctermbg=NONE
highlight nonText ctermbg=NONE

" I feel like I never get conceallevel right...
set conceallevel=0


let g:user_emmet_leader_key='<C-Z>'

" Tagbar
autocmd VimEnter * Tagbar

" Where should this go? Why do I turn filetype off above? What is life?
filetype on
filetype plugin indent on

" Easy Buffer movement; Do I need this still?
map gn :bn<cr>
map gp :bp<cr>
map gd :bd<cr>  

" Goyo
nnoremap <silent> <leader>z :Goyo<cr>
let g:goyo_width=100

" NERDTree
let NERDTreeQuitOnOpen = 1
map <silent> <C-n> :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" Multi Cursor Mapping
let g:multi_cursor_use_default_mapping=0
let g:multi_cursor_next_key='<C-s>'
let g:multi_cursor_prev_key='<C-p>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<Esc>'

" MRU
let MRU_Max_Entries = 400
map <leader>f :MRU<CR>

" Yankstack
let g:yankstack_yank_keys = ['y', 'd']
nmap <leader>p <Plug>yankstack_substitute_older_paste
nmap <leader>P <Plug>yankstack_substitute_newer_paste

" I try never to write python...
let g:virtualenv_directory = '.'

" Ale stuff
let g:ale_sign_column_always = 1
let g:ale_python_flake8_change_directory = 0
let g:ale_python_pylint_change_directory = 0
let g:ale_linters = {'jsx': ['stylelint', 'eslint']}
let g:ale_linters = {'js': ['stylelint', 'eslint']}
let g:ale_linters = {'typescript': ['stylelint', 'tslint']}
let g:ale_linters = {'ts': ['stylelint', 'tslint']}
let g:ale_linters = {'tsx': ['stylelint', 'tslint']}
let g:ale_fixers = {'javascript': ['prettier', 'eslint']}
let g:ale_fix_on_save = 1

" YCM never works like I want it to
let g:ycm_language_server =
\ [
\   {
\     'name': 'rust',
\     'cmdline': ['rust-analyzer'],
\     'filetypes': ['rust'],
\     'project_root_files': ['Cargo.toml']
\   }
\ ]

" Status Line
set statusline+=%#warningmsg#
set statusline+=%*

" Ack set to RG
let g:ackprg = 'rg --vimgrep'

" JSON
let g:vim_json_syntax_conceal = 0

" JSX
let g:jsx_ext_required = 0 " Allow JSX in normal JS files

" Long live tmux
if &term =~ '^screen'
    " tmux will send xterm-style keys when its xterm-keys option is on
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
endif

" Various handlings of file specific things
autocmd FileType tf setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType html setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType yaml setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType yml setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType javascript setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType javascript setlocal colorcolumn=100
autocmd FileType typescript setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType json setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType ruby setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType python setlocal omnifunc=jedi#completions
autocmd FileType python setlocal colorcolumn=80
autocmd FileType go setlocal colorcolumn=100
autocmd FileType crontab setlocal nobackup nowritebackup
autocmd FileType markdown setlocal colorcolumn=80 textwidth=80
autocmd FileType markdown let g:indentLine_setConceal=0

"Some Rust Stuff
let g:racer_experimental_completer = 1
autocmd FileType rust setlocal colorcolumn=100
autocmd FileType rust nmap gd <Plug>(rust-def)
autocmd FileType rust nmap gs <Plug>(rust-def-split)
autocmd FileType rust nmap gx <Plug>(rust-def-vertical)
autocmd FileType rust nmap <leader>gd <Plug>(rust-doc)
let g:rustfmt_autosave = 1
if executable('rls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'rls',
        \ 'cmd': {server_info->['rustup', 'run', 'nightly', 'rls']},
        \ 'whitelist': ['rust'],
        \ })
endif 

" Spell Bad because I spell bad....
hi clear SpellBad
hi SpellBad cterm=underline
