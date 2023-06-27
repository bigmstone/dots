vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("indent_blankline").setup {}
require("nvim-tree").setup({
    actions = {
        open_file = {
            quit_on_open = true,
        },
    },
})
