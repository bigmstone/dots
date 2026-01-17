local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
    ----------
    -- Base --
    ----------
    "folke/lazydev.nvim",
    { 'romgrk/barbar.nvim', version = '*', dependencies = 'nvim-tree/nvim-web-devicons'},
    { 'neovim/nvim-lspconfig' },
    { 'nvimtools/none-ls.nvim', dependencies = 'nvimtools/none-ls-extras.nvim' },
    {
      'nvim-treesitter/nvim-treesitter',
      lazy = false,
      branch = 'main',
      build = ':TSUpdate'
    },
    { 'L3MON4D3/LuaSnip', version = 'v2.*', build = 'make install_jsregexp' },

    ---------------
    -- Convience --
    ---------------
    'tpope/vim-fugitive',
    {
      'saghen/blink.cmp',
      dependencies = { 'rafamadriz/friendly-snippets' },
      version = '1.*',
      opts = {
        keymap = { preset = 'default' },

        appearance = {
          nerd_font_variant = 'mono'
        },

        completion = { documentation = { auto_show = false } },

        sources = {
          default = { 'lsp', 'path', 'snippets', 'buffer' },
          -- providers = {
          --   minuet = {
          --     name = 'minuet',
          --     module = 'minuet.blink',
          --     async = true,
          --     -- Should match minuet.config.request_timeout * 1000,
          --     -- since minuet.config.request_timeout is in seconds
          --     timeout_ms = 3000,
          --     score_offset = 50, -- Gives minuet higher priority among suggestions
          --   },
          -- },
        },

        fuzzy = { implementation = "prefer_rust_with_warning" }
      },
      opts_extend = { "sources.default" }
    },
    'tpope/vim-commentary',
    'yegappan/mru',
    'lukas-reineke/indent-blankline.nvim',
    { 'nvim-telescope/telescope.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },
    {
        'folke/trouble.nvim',
        opts = {
          modes = {
            diagnostics = { auto_open = true },
          },
          auto_close = true,
        },
        cmd = "Trouble",
        keys = {
          {
            "<leader>xx",
            "<cmd>Trouble diagnostics toggle<cr>",
            desc = "Diagnostics (Trouble)",
          },
          {
            "<leader>xX",
            "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
            desc = "Buffer Diagnostics (Trouble)",
          },
          {
            "<leader>cs",
            "<cmd>Trouble symbols toggle focus=false<cr>",
            desc = "Symbols (Trouble)",
          },
          {
            "<leader>cl",
            "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
            desc = "LSP Definitions / references / ... (Trouble)",
          },
          {
            "<leader>xL",
            "<cmd>Trouble loclist toggle<cr>",
            desc = "Location List (Trouble)",
          },
          {
            "<leader>xQ",
            "<cmd>Trouble qflist toggle<cr>",
            desc = "Quickfix List (Trouble)",
          },
        },
    },
    {
      "folke/which-key.nvim",
      event = "VeryLazy",
      keys = {
        {
          "<leader>?",
          function()
            require("which-key").show({ global = false })
          end,
          desc = "Buffer Local Keymaps (which-key)",
        },
      },
    },

    -----------
    -- Debug --
    -----------
    { 'rcarriga/nvim-dap-ui', dependencies = {'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio'} },

    ------------------
    -- Language/LSP --
    ------------------
    'ziglang/zig.vim',
    'preservim/vim-markdown',
    { 'nvim-tree/nvim-tree.lua', dependencies = { 'nvim-tree/nvim-web-devicons' } },
    { 'mrcjkb/rustaceanvim', version = '^6', lazy = false },
    {
      "apple/pkl-neovim",
      lazy = true,
      ft = "pkl",
      dependencies = {
        {
          "nvim-treesitter/nvim-treesitter",
          build = function(_)
            vim.cmd("TSUpdate")
          end,
        },
        "L3MON4D3/LuaSnip",
      },
      build = function()
        require('pkl-neovim').init()

        -- Set up syntax highlighting.
        vim.cmd("TSInstall pkl")
      end,
      config = function()
        -- Set up snippets.
        require("luasnip.loaders.from_snipmate").lazy_load()

        -- Configure pkl-lsp
        vim.g.pkl_neovim = {
          start_command = { "java", "-jar", "/path/to/pkl-lsp.jar" },
          -- or if pkl-lsp is installed with brew:
          -- start_command = { "pkl-lsp" },
          pkl_cli_path = "/path/to/pkl"
        }
      end,
    },

    ----------------
    -- Appearance --
    ----------------
    -- Colors First
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
    -- { "folke/tokyonight.nvim", lazy = false, priority = 1000, opts = {} },
    -- Rest of the appearance stuff
    'majutsushi/tagbar',
    'nvim-lualine/lualine.nvim',
    'rrethy/vim-illuminate',
    'Shatur/neovim-ayu',
    { "utilyre/barbecue.nvim", name = "barbecue", version = "*", dependencies = { "SmiteshP/nvim-navic", "nvim-tree/nvim-web-devicons" } },

    ---------------------------
    -- AI gon take our jarbs --
    ---------------------------
    {
        'milanglacier/minuet-ai.nvim',
        config = function()
            require('minuet').setup {
                virtualtext = {
                    auto_trigger_ft = {'*'},
                    keymap = {
                        -- accept whole completion
                        accept = '<A-A>',
                        -- accept one line
                        accept_line = '<A-a>',
                        -- accept n lines (prompts for number)
                        -- e.g. "A-z 2 CR" will accept 2 lines
                        accept_n_lines = '<A-z>',
                        -- Cycle to prev completion item, or manually invoke completion
                        prev = '<A-[>',
                        -- Cycle to next completion item, or manually invoke completion
                        next = '<A-]>',
                        dismiss = '<A-e>',
                    },
                },
                provider = "claude",
            }
        end,
    },
    {
      "NickvanDyke/opencode.nvim",
      dependencies = {
        -- Recommended for `ask()` and `select()`.
        -- Required for `snacks` provider.
        ---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
        { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
      },
      config = function()
        ---@type opencode.Opts
        vim.g.opencode_opts = {
          -- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition" on the type or field.
        }

        -- Required for `opts.events.reload`.
        vim.o.autoread = true

        -- Recommended/example keymaps.
        vim.keymap.set({ "n", "x" }, "<C-a>", function() require("opencode").ask("@this: ", { submit = true }) end, { desc = "Ask opencode…" })
        vim.keymap.set({ "n", "x" }, "<C-x>", function() require("opencode").select() end,                          { desc = "Execute opencode action…" })
        vim.keymap.set({ "n", "t" }, "<C-.>", function() require("opencode").toggle() end,                          { desc = "Toggle opencode" })

        vim.keymap.set({ "n", "x" }, "go",  function() return require("opencode").operator("@this ") end,        { desc = "Add range to opencode", expr = true })
        vim.keymap.set("n",          "goo", function() return require("opencode").operator("@this ") .. "_" end, { desc = "Add line to opencode", expr = true })

        vim.keymap.set("n", "<S-C-u>", function() require("opencode").command("session.half.page.up") end,   { desc = "Scroll opencode up" })
        vim.keymap.set("n", "<S-C-d>", function() require("opencode").command("session.half.page.down") end, { desc = "Scroll opencode down" })

        -- You may want these if you stick with the opinionated "<C-a>" and "<C-x>" above — otherwise consider "<leader>o…".
        vim.keymap.set("n", "+", "<C-a>", { desc = "Increment under cursor", noremap = true })
        vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement under cursor", noremap = true })
      end,
    },
}

require('lazy').setup(plugins, {})
