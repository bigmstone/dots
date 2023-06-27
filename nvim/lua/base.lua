vim.cmd([[
set noerrorbells
set scrolloff=3
set backspace=2
set textwidth=80
set linebreak
set autoindent
set smartindent
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
"set spell
"set spelllang=en_us


autocmd VimEnter * Tagbar
]])

-- Set lua mode for Command T
vim.cmd("let g:CommandTPreferredImplementation='lua'")

vim.api.nvim_set_keymap('n', '<C-n>', ':NvimTreeToggle<CR>', {noremap = true, silent = true})


vim.cmd([[
let g:user_emmet_leader_key='<C-Z>'
" fzf Map
map ; :Rg<CR>
]])
