-- vim.wo.relativenumber = true
vim.wo.number = true
vim.wo.cursorline = true
vim.wo.colorcolumn = '80'
vim.o.showmatch = true
vim.o.title = true
vim.o.background = 'dark'

-- vim.cmd.colorscheme("tokyonight-storm")
require("catppuccin").setup({
    flavour = "macchiato"
})
vim.cmd.colorscheme "catppuccin"
