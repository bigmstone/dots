-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Set leader key early
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Writing-focused options
vim.opt.textwidth = 80          -- Auto-wrap at 80 characters
vim.opt.wrap = true             -- Enable soft wrapping
vim.opt.linebreak = true        -- Break at word boundaries
vim.opt.breakindent = true      -- Maintain indentation on wrapped lines
vim.opt.spell = true            -- Enable spell checking
vim.opt.spelllang = { "en_us" } -- Set spell check language

-- Hide distracting UI elements
vim.opt.number = false          -- Hide line numbers
vim.opt.relativenumber = false  -- Hide relative line numbers
vim.opt.signcolumn = "no"       -- Hide sign column
vim.opt.foldcolumn = "0"        -- Hide fold column
vim.opt.colorcolumn = ""        -- Hide color column

-- Better editing experience
vim.opt.conceallevel = 2        -- Conceal markdown syntax for cleaner look
vim.opt.concealcursor = "nc"    -- Don't conceal on current line in normal/command mode
vim.opt.scrolloff = 8           -- Keep 8 lines visible above/below cursor
vim.opt.sidescrolloff = 8       -- Keep 8 columns visible left/right of cursor

-- Indentation for writing
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Better completion
vim.opt.completeopt = "menuone,noselect"

-- Essential keymaps for writing
local keymap = vim.keymap.set

-- Clear search highlighting
keymap("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Quick save
keymap("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })

-- Spell checking navigation
keymap("n", "]s", "]s", { desc = "Next misspelled word" })
keymap("n", "[s", "[s", { desc = "Previous misspelled word" })
keymap("n", "z=", "z=", { desc = "Spelling suggestions" })
keymap("n", "<leader>s", "<cmd>set spell!<CR>", { desc = "Toggle spell check" })

-- Better movement on wrapped lines
keymap("n", "j", "gj", { desc = "Move down visual line" })
keymap("n", "k", "gk", { desc = "Move up visual line" })
keymap("n", "0", "g0", { desc = "Go to beginning of visual line" })
keymap("n", "$", "g$", { desc = "Go to end of visual line" })

-- Focus on current paragraph (fold everything else)
keymap("n", "<leader>f", "zMzvzz", { desc = "Focus on current paragraph" })

-- Quick quit
keymap("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })

-- Setup lazy.nvim
require("lazy").setup({
  -- Distraction-free writing environment
  {
    "Pocco81/TrueZen.nvim",
    lazy = false,  -- Load immediately
    priority = 900,
    keys = {
      { "<leader>z", "<cmd>TZAtaraxis<CR>", desc = "Toggle Zen Mode" },
      { "<leader>m", "<cmd>TZMinimalist<CR>", desc = "Toggle Minimalist Mode" },
      { "<leader>F", "<cmd>TZFocus<CR>", desc = "Toggle Focus Mode" },
    },
    config = function()
      require("true-zen").setup({
        modes = {
          ataraxis = {
            ideal_writing_area_width = { 80 },
            auto_padding = true,
            keep_default_fold_fillchars = false,
            custom_bg = { "none", "" },
          },
          minimalist = {
            ignored_buf_types = { "nofile" },
            options = {
              number = false,
              relativenumber = false,
              showtabline = 0,
              signcolumn = "no",
              statusline = "",
              cmdheight = 1,
              laststatus = 0,
              showcmd = false,
              showmode = false,
              ruler = false,
              numberwidth = 1,
            },
          },
          focus = {
            callbacks = {
              open_pre = function()
                vim.wo.foldlevel = 99
              end,
            },
          },
        },
        integrations = {
          tmux = false,
          kitty = {
            enabled = false,
          },
        },
      })

      -- Auto-activate zen mode after setup
      vim.defer_fn(function()
        vim.cmd("TZAtaraxis")
      end, 200)
    end,
  },

  -- Beautiful markdown rendering - ALWAYS ACTIVE
  {
    "MeanderingProgrammer/render-markdown.nvim",
    lazy = false,  -- Load immediately, not just for markdown files
    priority = 800,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("render-markdown").setup({
        heading = {
          enabled = true,
          sign = false,
          icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
        },
        code = {
          enabled = true,
          sign = false,
          style = "full",
          left_pad = 2,
          right_pad = 2,
        },
        bullet = {
          enabled = true,
          icons = { "●", "○", "◆", "◇" },
        },
        -- Enable for all buffers, not just markdown
        file_types = { "markdown", "text", "" }, -- "" enables for buffers without filetype
      })
    end,
  },

  -- Better bullet point management - ALWAYS ACTIVE
  {
    "bullets-vim/bullets.vim",
    lazy = false,  -- Load immediately, not just for specific filetypes
    priority = 700,
    config = function()
      -- Enable for all file types since this is a writing-focused config
      vim.g.bullets_enabled_file_types = { "markdown", "text", "" }
      vim.g.bullets_enable_in_empty_buffers = 1  -- Enable in empty buffers too
      vim.g.bullets_set_mappings = 1
      vim.g.bullets_mapping_leader = ""
    end,
  },

  -- Auto-save for uninterrupted writing flow
  {
    "okuuva/auto-save.nvim",
    event = { "InsertLeave", "TextChanged" },
    config = function()
      require("auto-save").setup({
        enabled = true,
        execution_message = {
          enabled = false, -- Don't show save messages
        },
        trigger_events = {
          immediate_save = { "BufLeave", "FocusLost" },
          defer_save = { "InsertLeave", "TextChanged" },
          cancel_defered_save = { "InsertEnter" },
        },
        condition = function(buf)
          -- Don't auto-save if buffer is not modifiable
          if not vim.bo[buf].modifiable then
            return false
          end

          -- Auto-save all files in writing mode (not just markdown)
          return true
        end,
        write_all_buffers = false,
        debounce_delay = 5000, -- 5 seconds
      })
    end,
  },

  -- Treesitter for better syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    main = "nvim-treesitter.config",
    opts = {
      ensure_installed = { "markdown", "markdown_inline" },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
    },
  },

  -- Simple colorscheme for distraction-free writing
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "night",
        transparent = false,
        terminal_colors = true,
        styles = {
          comments = { italic = true },
          keywords = { italic = true },
          functions = {},
          variables = {},
          sidebars = "dark",
          floats = "dark",
        },
        sidebars = { "qf", "help" },
        day_brightness = 0.3,
        hide_inactive_statusline = false,
        dim_inactive = false,
        lualine_bold = false,
      })
      vim.cmd.colorscheme("tokyonight")
    end,
  },
}, {
  -- Lazy.nvim configuration
  ui = {
    border = "rounded",
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

-- Set default filetype to markdown for new buffers
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  callback = function()
    -- If buffer has no filetype and no extension, assume it's markdown
    if vim.bo.filetype == "" and vim.fn.expand("%:e") == "" then
      vim.bo.filetype = "markdown"
    end
  end,
})

-- Show a welcome message
print("📝 Full writing mode activated! Zen, markdown rendering, and bullets ready to go!")
