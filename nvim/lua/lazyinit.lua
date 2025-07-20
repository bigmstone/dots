local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
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
      build = function(_)
        vim.cmd('TSUpdate')
      end,
    },
    { 'L3MON4D3/LuaSnip', version = 'v2.*', build = 'make install_jsregexp' },

    ---------------
    -- Convience --
    ---------------
    'tpope/vim-fugitive',
    'hrsh7th/nvim-cmp',
    { 'hrsh7th/cmp-nvim-lsp', dependencies = 'hrsh7th/nvim-cmp' },
    { 'hrsh7th/cmp-buffer', dependencies = 'hrsh7th/nvim-cmp' },
    { 'hrsh7th/nvim-cmp', dependencies = 'hrsh7th/nvim-cmp' },
    { 'hrsh7th/cmp-cmdline', dependencies = 'hrsh7th/nvim-cmp' },
    { 'hrsh7th/cmp-path', dependencies = 'hrsh7th/nvim-cmp' },
    'tpope/vim-commentary',
    'yegappan/mru',
    'lukas-reineke/indent-blankline.nvim',
    { 'nvim-telescope/telescope.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },
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
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
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
    {
      "yetone/avante.nvim",
      event = "VeryLazy",
      version = false, -- Never set this value to "*"! Never!
      opts = {
        -- add any opts here
        -- for example
        providers = {
          openai = {
            endpoint = "https://api.openai.com/v1",
            model = "gpt-4o", -- your desired model (or use gpt-4o, etc.)
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
        "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
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
    }
}

require('lazy').setup(plugins, {})
