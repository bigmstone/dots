vim.opt.errorbells = false
vim.opt.clipboard = "unnamedplus"
vim.opt.scrolloff = 3
vim.opt.backspace = "2"
vim.opt.textwidth = 0
vim.opt.linebreak = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.api.nvim_create_autocmd("VimEnter", {
    pattern = "*",
    command = "Tagbar"
})

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


vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {
    desc = "Go to definition",
    silent = true,
    noremap = true
})


---------
-- MRU --
---------
vim.keymap.set("n", "<leader>f", ":MRU<CR>", {})
