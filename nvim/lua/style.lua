vim.cmd([[
set cursorline
set number
set background=dark
set title
set showmatch
set colorcolumn=80
]])

require("monokai-pro").setup({})
vim.cmd([[colorscheme monokai-pro-ristretto]])
