vim.cmd([[
    set noerrorbells
    set clipboard=unnamedplus
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
    autocmd VimEnter * Tagbar
]])

vim.g.vim_markdown_folding_disabled = 1
vim.g.table_mode_corner = '|'
vim.api.nvim_set_keymap('n', '<C-n>', ':NvimTreeToggle<CR>', {noremap = true, silent = true})
vim.g.user_emmet_leader_key='<C-Z>'
vim.g.rustfmt_autosave = 1
vim.o.signcolumn = "yes"

local builtin = require('telescope.builtin')
vim.keymap.set('n', ';', builtin.live_grep, {})
vim.keymap.set('n', '<leader>ft', builtin.treesitter, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>ac', "<cmd>NeoAIContext<cr>", {})


---------
-- MRU --
---------
vim.keymap.set("n", "<leader>f", ":MRU<CR>", {})
