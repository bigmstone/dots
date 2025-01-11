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
    { 'mrcjkb/rustaceanvim', version = '^5', lazy = false },

    ----------------
    -- Appearance --
    ----------------
    'majutsushi/tagbar',
    'nvim-lualine/lualine.nvim',
    'rrethy/vim-illuminate',
    'Shatur/neovim-ayu',
    { "folke/tokyonight.nvim", lazy = false, priority = 1000, opts = {} },
    { "utilyre/barbecue.nvim", name = "barbecue", version = "*", dependencies = { "SmiteshP/nvim-navic", "nvim-tree/nvim-web-devicons" } }
}

require('lazy').setup(plugins, {})
