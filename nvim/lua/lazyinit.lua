local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
    ----------
    -- Base --
    ----------
    { 'nvim-tree/nvim-tree.lua', dependencies = { 'nvim-tree/nvim-web-devicons' } },
    'nvim-tree/nvim-web-devicons',
    {'neoclide/coc.nvim', branch = 'release'},
    'majutsushi/tagbar',
    'tpope/vim-commentary',
    'yegappan/mru',
    { 'nvim-telescope/telescope.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },
    'lukas-reineke/indent-blankline.nvim',
    'tpope/vim-fugitive',
    'rrethy/vim-illuminate',
    'junegunn/goyo.vim',
    'nvim-lualine/lualine.nvim',
    'romgrk/barbar.nvim',

    -----------------------
    -- Language Specific --
    -----------------------
    'rust-lang/rust.vim',
    'ziglang/zig.vim',
    'tikhomirov/vim-glsl',
    'preservim/vim-markdown',
    'dhruvasagar/vim-table-mode',
    { 'monkoose/nvlime', dependencies = { 'monkoose/parsley' } },
    'gpanders/nvim-parinfer',
    {
      "nvim-treesitter/nvim-treesitter",
      build = function(_)
        vim.cmd("TSUpdate")
      end,
    },
    {
      "https://github.com/apple/pkl-neovim",
      lazy = true,
      event = "BufReadPre *.pkl",
      dependencies = {
        "nvim-treesitter/nvim-treesitter",
      },
      build = function()
        vim.cmd("TSInstall! pkl")
      end,
    },

    ------------
    -- Colors --
    ------------
    'Shatur/neovim-ayu',

    ------------------
    -- Experimental --
    ------------------
    'MunifTanjim/nui.nvim',
    {
        "Bryley/neoai.nvim",
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
        cmd = {
            "NeoAI",
            "NeoAIOpen",
            "NeoAIClose",
            "NeoAIToggle",
            "NeoAIContext",
            "NeoAIContextOpen",
            "NeoAIContextClose",
            "NeoAIInject",
            "NeoAIInjectCode",
            "NeoAIInjectContext",
            "NeoAIInjectContextCode",
        },
        keys = {
            { "<leader>as", desc = "summarize text" },
            { "<leader>ag", desc = "generate git message" },
        },
        config = function()
            require("neoai").setup({
                models = {
                    {
                        name = "openai",
                        model = "gpt-4",
                        params = nil,
                    },
                },
            })
        end,
    },
}

require("lazy").setup(plugins, {})
