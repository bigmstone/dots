vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

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
    actions = {
        open_file = {
            quit_on_open = true,
        },
    },
})
require('lualine').setup({ options = { theme = 'tokyonight-storm' } })
require('illuminate').configure({})
require('barbecue').setup {
  theme = 'tokyonight-storm',
}

local null_ls = require("null-ls")
null_ls.setup({
    sources = {
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.completion.spell,
        require("none-ls.diagnostics.eslint"),
    },
})

require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = { "lua_ls", "pyright", "ruff" },
})

require('lspconfig').lua_ls.setup {
    capabilities = vim.g.lsp_capabilities,
}

require('lspconfig').pyright.setup {
  capabilities = vim.g.lsp_capabilities,
  settings = {
    pyright = {
      -- Using Ruff's import organizer
      disableOrganizeImports = true,
    },
    python = {
      analysis = {
        -- Ignore all files for analysis to exclusively use Ruff for linting
        ignore = { '*' },
      },
    },
  },
}

vim.api.nvim_create_autocmd("BufWritePre", {
  buffer = bufnr,
  callback = function()
    vim.lsp.buf.code_action({
      context = { only = { "source.fixAll" }, diagnostics = {} },
      apply = true,
    })
  end,
})

require('lspconfig').ruff.setup {
    capabilities = vim.g.lsp_capabilities,
}

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

require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the listed parsers MUST always be installed)
  ensure_installed = {
    "c", "lua", "markdown", "markdown_inline", "query", "svelte", "typescript",
    "vim", "vimdoc", "c", "lua", "markdown", "markdown_inline", "query", "vim",
    "vimdoc"
  },
  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (or "all")
  ignore_install = { "javascript" },

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    disable = { "c" },
    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
    end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
