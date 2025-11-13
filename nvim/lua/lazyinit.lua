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
    'majutsushi/tagbar',
    'nvim-lualine/lualine.nvim',
    'rrethy/vim-illuminate',
    'Shatur/neovim-ayu',
    { "folke/tokyonight.nvim", lazy = false, priority = 1000, opts = {} },
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
      "yetone/avante.nvim",
      event = "VeryLazy",
      version = false, -- Never set this value to "*"! Never!
      opts = {
        behaviour = {
          auto_focus_sidebar = false,
          auto_approve_tool_permissions = false,
        },
        providers = {
          claude = {
            endpoint = "https://api.anthropic.com",
            model = "claude-sonnet-4-5",
            timeout = 30000, -- Timeout in milliseconds
              extra_request_body = {
                temperature = 0.75,
                max_tokens = 20480,
              },
          },
          openai = {
            endpoint = "https://api.openai.com/v1",
            model = "gpt-5-mini", -- your desired model (or use gpt-4o, etc.)
            timeout = 30000, -- Timeout in milliseconds, increase this for reasoning models
            extra_request_body = {
              temperature = 0,
              max_completion_tokens = 8192, -- Increase this to include reasoning tokens (for reasoning models)
              reasoning_effort = "medium", -- low|medium|high, only used for reasoning models
            },
          },
        },
      },
      -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
      build = "make",
      -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
      dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "stevearc/dressing.nvim",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        --- The below dependencies are optional,
        "echasnovski/mini.pick", -- for file_selector provider mini.pick
        "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
        "ibhagwan/fzf-lua", -- for file_selector provider fzf
        "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
        "zbirenbaum/copilot.lua", -- for providers='copilot'
        {
          -- support for image pasting
          "HakonHarnes/img-clip.nvim",
          event = "VeryLazy",
          opts = {
            -- recommended settings
            default = {
              embed_image_as_base64 = false,
              prompt_for_file_name = false,
              drag_and_drop = {
                insert_mode = true,
              },
              -- required for Windows users
              use_absolute_path = true,
            },
          },
        },
        {
          -- Make sure to set this up properly if you have lazy=true
          'MeanderingProgrammer/render-markdown.nvim',
          opts = {
            file_types = { "markdown", "Avante" },
          },
          ft = { "markdown", "Avante" },
        },
      },
    },
}

require('lazy').setup(plugins, {})
