-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1

-- Configure diagnostics
vim.diagnostic.config({
    virtual_text = true,  -- Show inline hints
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
})

require("ibl").setup()
require("nvim-tree").setup({
    diagnostics = {
        enable=true,
        show_on_dirs=true
    },
    disable_netrw = false,
    hijack_netrw = false,
    actions = {
        open_file = {
            quit_on_open = true,
        },
    },
})
require('lualine').setup({})
require('illuminate').configure({})
require('barbecue').setup({})

-- Load minimal LSP configuration
require('lsp')

-- Simple formatter setup using null-ls
local null_ls = require("null-ls")
null_ls.setup({
    sources = {
        null_ls.builtins.formatting.stylua,
        require("none-ls.diagnostics.eslint"),
    },
})

-- Configure rustaceanvim for better Rust experience
vim.g.rustaceanvim = {
    server = {
        on_attach = function(client, bufnr)
            -- Enable inlay hints if supported
            if client.server_capabilities.inlayHintProvider then
                vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
            end
            
            -- Set up buffer-local keymaps
            local opts = { buffer = bufnr, noremap = true, silent = true }
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
            vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
            vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
            vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts)
            vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, opts)
        end,
        capabilities = vim.g.lsp_capabilities,
        default_settings = {
            ['rust-analyzer'] = {
                checkOnSave = true,
                check = {
                    command = "clippy",
                },
                inlayHints = {
                    parameterHints = { enable = true },
                    typeHints = { enable = true },
                },
            },
        },
    },
}

require("dapui").setup()

local dap, dapui = require("dap"), require("dapui")
dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end

local wk = require("which-key")
wk.add({
  { "<leader>f", group = "file" }, -- group
  { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find File", mode = "n" },
  { "<leader>fb", function() print("hello") end, desc = "Foobar" },
  { "<leader>fn", desc = "New File" },
  { "<leader>f1", hidden = true }, -- hide this keymap
  { "<leader>w", proxy = "<c-w>", group = "windows" }, -- proxy to window mappings
  { "<leader>b", group = "buffers", expand = function()
      return require("which-key.extras").expand.buf()
    end
  },
  {
    -- Nested mappings are allowed and can be added in any order
    -- Most attributes can be inherited or overridden on any level
    -- There's no limit to the depth of nesting
    mode = { "n", "v" }, -- NORMAL and VISUAL mode
    { "<leader>q", "<cmd>q<cr>", desc = "Quit" }, -- no need to specify mode since it's inherited
    { "<leader>w", "<cmd>w<cr>", desc = "Write" },
  }
})

require'nvim-treesitter'.install { 'all' }

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'svelte' },
  callback = function() vim.treesitter.start() end,
})
