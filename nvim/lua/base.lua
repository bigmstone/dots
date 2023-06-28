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

---------------------
-- Some CoC Things --
---------------------
function _G.check_back_space()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

vim.opt.signcolumn = "yes"
local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}
vim.keymap.set("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
vim.keymap.set("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)
vim.keymap.set("i", "<C-j>", "<Plug>(coc-snippets-expand-jump)")
vim.keymap.set("n", "[g", "<Plug>(coc-diagnostic-prev)", {silent = true})
vim.keymap.set("n", "]g", "<Plug>(coc-diagnostic-next)", {silent = true})
vim.keymap.set("n", "gd", "<Plug>(coc-definition)", {silent = true})
vim.keymap.set("n", "gy", "<Plug>(coc-type-definition)", {silent = true})
vim.keymap.set("n", "gi", "<Plug>(coc-implementation)", {silent = true})
vim.keymap.set("n", "gr", "<Plug>(coc-references)", {silent = true})


---------------------
-- Some MRU Things --
---------------------
vim.keymap.set("n", "<leader>f", ":MRU<CR>", {})
