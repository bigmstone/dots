vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("ibl").setup()
require("nvim-tree").setup({
    diagnostics = {
        enable=true,
        show_on_dirs=true
    },
    actions = {
        open_file = {
            quit_on_open = true,
        },
    },
})
require('lualine').setup({ options = { theme = 'ayu' } })
require('illuminate').configure({})
require('barbar').setup({})
